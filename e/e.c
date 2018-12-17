/* Estimate e using numerical differentiation.
 * ==> Find e such that d/dx e^x = e^x
 */

#include<math.h>
#include<stdio.h>

void colour_print(double estimate);
double dfdx(double e, double x, double h);
double f(double e, double x);
double fit_error(double e, double a, double b, double step);
int main();

// evaluate e^x - d/dx e^x on this interval:
const double INTERVAL_LOW = -1;
const double INTERVAL_HIGH = 2;
// step size for sampling points within the interval:
const double SAMPLE_STEP = 5e-4;
// value of h for differentiating e^x
const double DIFF_H = 1e-04;
// Reference digits of e, for colouring output:
const char*  E_STRING = "2.71828182845904523536028747135266249775724709369995";

int
main()
{
        // bracket e:
        double high = 3; 
        double low = 2.5;

        double mid;
        double interval = high - low;

        double tol = 1e-15; // stop when we narrow interval to this size

        double derivative;
        double h = 1e-8;    // h for calculating derivative of fit_error

        double forward[2]; 
        double backward[2];
        int i;

        /*
         * Use binary search and derivative of fit_error
         * to find e with lowest rmsd of d/dx e^x from e^x
         */
        printf("Estimate of e:\n"); 
        while(interval > tol){
                mid = low + (high - low) / 2;
                backward[0] = fit_error(mid -  h, INTERVAL_LOW,
                                INTERVAL_HIGH, SAMPLE_STEP);
                forward[0]  = fit_error(mid + h, INTERVAL_LOW,
                                INTERVAL_HIGH, SAMPLE_STEP);
                forward[1]  = fit_error(mid + 2*h, INTERVAL_LOW,
                                INTERVAL_HIGH, SAMPLE_STEP);
                backward[1]  = fit_error(mid - 2*h, INTERVAL_LOW,
                                INTERVAL_HIGH, SAMPLE_STEP);
                derivative = (
                                - forward[1]  +
                                8 * forward[0]  + 
                                -8 * backward[0] + 
                                backward[1]
                             ) / (h * 12); 

                if (derivative == 0) break;
                if (derivative > 0) high = mid;
                if (derivative < 0) low = mid;
                interval = high - low;

                colour_print(mid);
        }
        fputs("\x1b[0m", stdout); // reset colour
        return 0;
}

/*
 * Print accurate digits of estimate in green,
 * inaccurate digits in red.
 */
void
colour_print(double estimate)
{
        char buffer[50];
        int match = 0;
        int i;

        snprintf(buffer, 50, "%.15f", estimate);

        fputs("\x1b[32m", stdout); // green
        while(buffer[match] == E_STRING[match])
                match++;
        for(i = 0; i < match; i++)
                putchar(buffer[i]);

        fputs("\x1b[31m", stdout); // red
        puts(buffer + match);
}

/*
 * For candidate value of e, calculate fit between d/dx e^x  and  e^x.
 *
 * Sample points at inteval step between a and b.
 * Estimate derivative of e^x at each sample point.
 * Return RMSD of d/dx e^x w.r.t. e^x.
 */
double
fit_error(double e, double a, double b, double step)
{
        double rmsd = 0;
        double err;
        double x;
        double dydx;

        for(x = a; x <= b; x += step){
                err = f(e, x) - dfdx(e, x, DIFF_H); 
                rmsd += err * err;
        }
        return sqrt(rmsd);
}


/*
 * Estimate d/dx e^x numerically
 */
double 
dfdx(double e, double x, double h)
{
        return ( -1 * f(e, x + 2*h)  +
                  8 * f(e, x + h)    +
                 -8 * f(e, x - h)    +
                  1 * f(e, x - 2*h)
               ) / (12 * h);

}

/* 
 * f(x) = e^x
 */
double
f(double e, double x)
{
        return pow(e, x);
}
