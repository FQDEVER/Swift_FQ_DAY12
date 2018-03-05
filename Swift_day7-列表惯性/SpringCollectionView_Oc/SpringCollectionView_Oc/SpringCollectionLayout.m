//
//  SpringCollectionLayout.m
//  SpringCollectionView_Oc
//
//  Created by mac on 2018/1/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SpringCollectionLayout.h"

@interface SpringCollectionLayout()

@property (strong, nonatomic) UIDynamicAnimator *animator;
@end

@implementation SpringCollectionLayout

-(void)prepareLayout
{
    [super prepareLayout];

    if (!_animator) {

        CGSize contentSize = self.collectionViewContentSize;
        _animator = [[UIDynamicAnimator alloc]initWithCollectionViewLayout:self];
        NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        for (UICollectionViewLayoutAttributes * item in items) {
            UIAttachmentBehavior * spring  = [[UIAttachmentBehavior alloc]initWithItem:item attachedToAnchor:item.center];
            spring.length = 0;
            spring.damping = 0.5;
            spring.frequency = 0.8;
            [_animator addBehavior:spring];
        }
    }
}



-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [_animator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
   return  [_animator layoutAttributesForCellAtIndexPath:indexPath];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{

    CGFloat scrollDelta = newBounds.origin.y - (self.collectionView.bounds.origin.y);
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    for (UIAttachmentBehavior * spring in _animator.behaviors) {
        CGPoint anchorPoint = spring.anchorPoint;
        CGFloat distaceFormTouch = fabsf(touchLocation.y - anchorPoint.y);
        CGFloat scrollResistance = distaceFormTouch / 500.0;
        UICollectionViewLayoutAttributes  * springItem = spring.items.firstObject;
        CGPoint center = springItem.center;
        center.y += (scrollDelta > 0) ? MIN(scrollDelta, scrollDelta * scrollResistance) : MAX(scrollDelta, scrollDelta * scrollResistance);
        springItem.center = center;
        [_animator updateItemUsingCurrentState:springItem];

    }
    return NO;
}

@end
