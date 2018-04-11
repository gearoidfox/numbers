/*
 * Print all pairs of coprime integers less than or equal to argument N.
 */

#include<stdio.h>
#include<stdlib.h>

/* Ternary tree with a pair of numbers x,y at each node */
struct tnode{
        struct tnode *left;
        struct tnode *centre;
        struct tnode *right; 
        unsigned int x, y;
};


/* add_children()
 * Given a pointer to a root node, populate a ternary tree with unique pairs of
 * coprime integers at each node. The formulas for each child node are:
 * left child (x', y') = (2x - y, x)
 * middle child (x', y') = (2x + y, x)
 * right child (x', y') = (x + 2y, y)
 */
void
add_children(struct tnode *node_ptr, unsigned int max)
{
        /* x,y for children based on x,y of current node: */
        unsigned int lx, ly, cx, cy, rx, ry;
        lx =  2 * node_ptr->x - node_ptr->y;
        cx =  2 * node_ptr->x + node_ptr->y;
        rx =  node_ptr->x + 2 * node_ptr->y;
        ly = cy = node_ptr->x;
        ry = node_ptr->y;

        /* Fill left subtreea */
        if( lx <= max && ly <= max ){
                node_ptr->left = malloc(sizeof(*node_ptr->left));
                if(node_ptr->left == NULL)
                        exit(1);
                node_ptr->left->x = lx;
                node_ptr->left->y = ly;
                add_children(node_ptr->left, max);
        } else {
                node_ptr->left = NULL;
        }
        /* Fill middle subtree */
        if( cx <= max && cy <= max ){
                node_ptr->centre = malloc(sizeof(*node_ptr->centre));
                if(node_ptr->centre == NULL)
                        exit(1);
                node_ptr->centre->x = cx;
                node_ptr->centre->y = cy;
                add_children(node_ptr->centre, max);
        } else {
                node_ptr->centre = NULL;
        }
        /* Fill right subtree */
        if( rx <= max && ry <= max ){
                node_ptr->right = malloc(sizeof(*node_ptr->right));
                if(node_ptr->right == NULL)
                        exit(1);
                node_ptr->right->x = rx;
                node_ptr->right->y = ry;
                add_children(node_ptr->right, max);
        } else {
                node_ptr->right = NULL;
        }
        return;
}

/* print_pairs
 * Given a tree populated with nodes by add_children(), visit each node
 * (depth first) and print the pair of coprime integers x and y.
 */
void
print_pairs(struct tnode *tree){
        printf("%u %u\n", tree->x, tree->y);
        if (tree->left != NULL){
                print_pairs(tree->left);
        }
        if (tree->centre != NULL){
                print_pairs(tree->centre);
        }
        if (tree->right != NULL){
                print_pairs(tree->right);
        }
        return;
}

/*
 * Create two trees with roots (2,1) and (3,1), then print the pairs at every
 * node of these trees.
 */
int
main(int argc, char **argv)
{
        /* Specify maximum value N as an argument. Default value 100 */
        unsigned int max = 100;
        struct tnode root1, root2;
        if(argc > 1){
                max = atoi(argv[1]);
        }
        root1.x = 2;
        root1.y = 1;
        root2.x = 3;
        root2.y = 1;
        add_children(&root1, max);
        add_children(&root2, max);
        print_pairs(&root1);
        print_pairs(&root2);
        return 0;
}
