#include<ctime>
#include<iostream>
#include<cmath>
#include<random>

int main()
{
        // PRNG: Mersenne Twister, uniform distribution over [0, 1)
        // seed with current time
        std::mt19937_64 engine;
        engine.seed(std::time(NULL));
        std::uniform_real_distribution<double> uniform01(0.0, 1.0);
        unsigned long N[] = {1000, 10000, 1000000, 10000000, 100000000};
        double x;
        double y;
        double pi;
        unsigned long hits;
        for(int i = 0; i < 5; ++i){ // Loop over alterative values for N
                hits = 0;
                for(int j = 0; j < N[i]; ++j){
                        x = uniform01(engine);
                        y = uniform01(engine);
                        if (x * x + y * y <= 1) ++hits;
                }
                std::cout.precision(10);
                pi = (4.0 * hits) / N[i];
                std::cout << "Points sampled: " << N[i] << "; ";
                std::cout << "Estimate: " << pi << "; ";
                std::cout << "Error: " << fabs(M_PI - pi) << std::endl;
        }
        return 0;
}
