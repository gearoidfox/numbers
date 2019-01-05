/* farey.c
 * 
 * Calculate Farey Sequences.
 *
 * Argument: maximum denominator for numbers in the sequence.
 */

#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>

struct rational {
        struct rational *next;
        long num;
        long denom;
};

struct rational * farey(long a, long b, long c, long d, long max_denom);
void deallocate(struct rational * list);


int
main(int argc, char** argv)
{
        struct rational *head;
        struct rational *elem;
        
        struct rational *inner_head;
        struct rational *inner_elem;
        
        long max_denom = 10; // maximum denominator, final pass (default)
        long outer_max = 50; // maximum denominator, first pass

        if (argc > 2) {
                return 0;
        } else if (argc == 2) {
                max_denom = atoi(argv[1]);
                if (max_denom < 1) return 1;
                if (max_denom < outer_max) outer_max = max_denom;
        }
        
        // Do a rough division of the interval:
        head = farey(0, 1, 1, 1, outer_max);
        if(NULL == head){
                fprintf(stderr, "Error.\n");
                return 1;
        }
        // We have a list of reduced fractions with denominator 
        // <= outer_max. Between each pair of elements in the
        // list, calculate a new list of fractions with denominators
        // less than max_denom.
        // We allocate and deallocate memory for the inner list
        // at each interval, so we don't run out.
        elem = head;
        while (NULL != elem) { // iterate over elements in the first list
                printf("%lu %lu\n", elem->num, elem->denom);
                if(elem->next != NULL) {
                        inner_head = farey(elem->num, elem->denom,
                                        elem->next->num, elem->next->denom,
                                        max_denom);
                        if(NULL == inner_head){
                                fprintf(stderr, "Error.\n");
                                return 1;
                        }
                        inner_elem = inner_head->next;
                        // iterate over the new list 
                        while(NULL != inner_elem->next){
                                printf("%lu %lu\n", inner_elem->num, inner_elem->denom);
                                inner_elem = inner_elem->next;
                        }
                        deallocate(inner_head);
                }
                
                elem = elem->next;
        }
        
        deallocate(head);

        return 0;
}



/* farey
 *
 * Create a linked-list of all rationals between a/b and c/d with denominators
 * less than max_denom.
 *
 * Returns pointer to a linked list of (struct rational) or NULL on error. 
 */
struct rational *
farey(long a, long b, long c, long d, long max_denom)
{
        struct rational *head;
        struct rational *tail;
        struct rational *elem;
        struct rational *new;

        if(a / (double) b >= c / (double) d){
                return NULL;
        }

        // Create head and tail pointers for a singly-linked list of rationals:
        head = malloc(sizeof(*head));
        tail = malloc(sizeof(*tail));
        if(NULL == head || NULL == tail) {
                return NULL;
        }

        head->next = tail;
        head->num = a;
        head->denom = b;

        tail->next = NULL;
        tail->num = c;
        tail->denom = d;

        /*
         * Insert rationals into list
         *
         * Inner loop iterates one time over elements of current list, adding a
         * new rational a+c/b+d between each pair of rationals a/b, c/d.
         *
         * No element is added if the new denomiator b+d is greater than the
         * maximum specified by max_denom.
         *
         * Outer loop runs until an iteration of the inner loop adds no new
         * elements to the list. 
         *
         */ 
        long added = 1;
        while(added > 0) { // outer loop
                added = 0;
                elem = head;
                while(elem != tail){ // inner loop
                        // test if new denominator is too big:
                        if(elem->denom + elem->next->denom > max_denom){
                                elem = elem->next;
                                continue;
                        }

                        new = malloc(sizeof(*new));
                        /* If malloc fails, free our previously allocated
                         * memory and return NULL;
                         */
                        if(NULL == new){
                                deallocate(head); 
                                return NULL;      
                        }
                        ++added;
                        new->next = elem->next;
                        elem->next = new;

                        new->num = elem->num + new->next->num;
                        new->denom = elem->denom + new->next->denom;

                        elem = new->next;
                } 
        }
        return head;
}



/* deallocate
 *
 * Free a linked-list created by farey()
 */
void
deallocate(struct rational * list)
{
        struct rational *elem;
        struct rational *next;
        elem = list;
        while(NULL != elem){
                next = elem->next;
                free(elem);
                elem = next;
        }
        return;
}
