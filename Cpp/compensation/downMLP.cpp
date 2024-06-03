#include <cmath>
#include "compensation.h"
#include "unstable.h"

using namespace std;

void downMLP(float x[6], float y[6])
{

    // Neural Network Constants
    float x1_step1_xoffset[6] = {33.8642258683517, 31.0575210194726, 32.252259094128, 30.0489910653656, 32.6627226909759, 33.8248346312001};
    float x1_step1_gain[6] = {0.0634965184865048, 0.0571012988546179, 0.0597657990889494, 0.0551377157559082, 0.0613418808697868, 0.0616987250221067};
    float x1_step1_ymin = -1;

    float b1[10] = {0.87126130952516467332, 0.75188004527111329534, 0.67818576792568363576, -0.66753736256202622634, 0.73020693611423281855, -0.7713083912699371103, 0.72892838952748961745, -0.73636065513138182492, 0.72124086704449197338, 0.7322810293696827566};
    float IW1_1[10][6] = {
        {-0.52048506004074934772, 0.16054462477622266636, -0.10490351381396573194, -0.12606231201186859914, 0.096360503263979893629, 0.18213741826551602121},
        {-0.0022136458302208688112, 0.054440419401171342983, -0.025550838877906059676, -0.27143816163841949507, 0.15975351534495887962, -0.11204363236871932308},
        {-0.0097578096645175964319, -0.11279601044080703187, 0.03790386293954474406, -0.037596770060871864683, -0.16518230046089432683, 0.090287801700909831037},
        {-0.0099369302231942686909, 0.10538242140769607524, 0.014723735676814992887, -0.0056162912887360279604, 0.084454204188531570296, -0.0079499265274904779011},
        {0.12114012004416392643, -0.13494684177290700022, 0.053913510603677168576, 0.019557399683898118309, -0.091704661046691504644, -0.22696387146955501746},
        {-0.028547384532164044035, -0.081310842922745901751, 0.086513927302810655906, 0.15761945835600746357, -0.0695873107126592505, 0.10764319346299025537},
        {0.21553065816116853681, 0.056863023557259785579, -0.13680305611245402453, -0.019908870330479111477, 0.070326502284465131076, -0.49890553633088136065},
        {-0.063736956683591777795, -0.10647760015257469457, 0.14704162939514656139, 0.05589793143462995495, -0.012838231381760205341, 0.19540827284295431143},
        {0.044326930730042748974, -0.089253889085941520709, 0.036892388158188557656, 0.012984796644912499977, -0.20602846181088479982, -0.053165732843676802299},
        {0.044416045046715472988, -0.15164575962906909345, -0.054871116573624784118, 0.056774640761829288371, -0.062831210513958055119, -0.016212626045327846458}};

    float b2[6] = {5.1859280306874087074, -4.4362905208708092175, 9.0772272660909862907, 11.302581446624690997, 30.53091475016765699, -1.6156412665475954338};
    float LW2_1[6][10] = {
        {0.95161190477885326811, 12.191535285794879329, -20.749223866428248897, -43.091190109729218705, -4.1637088478007209247, 36.135469589018079262, 1.2345808200246410902, -20.238154986106206223, -4.5578936404648855429, -18.086090917023643243},
        {-2.0449971727388973619, -10.492045374461469009, -5.8359962608773621184, 16.234200442412458187, -8.3719140920222869795, -20.338536197897976621, 3.7625815428756315129, 12.33353735253932193, 6.8497166396467443761, 29.889399970992680977},
        {1.4418769153191282051, 15.851227559540234324, 45.7541076118873562, 120.59117424764710336, 8.4407561552430010465, 38.035990349671521926, -4.3793168025191073767, -27.025720486321226588, -6.863584193578387449, 52.610942888275410212},
        {-0.64738775093164235841, 32.807013154187323778, 147.47695239330244021, 187.19803998429313197, 114.23769853263530649, 168.67835157218402742, -58.062573561749125872, -197.95787052695990837, -124.09481921015056116, 27.242764514313154933},
        {-6.3305410074378789531, 113.43377893137544277, -25.727047237639670385, -71.964366356110815559, -22.470574907421880795, 256.0084636849867934, -12.671424804414677112, -112.39035036925886857, 13.304779758744947671, -25.821496556079043927},
        {-4.2048092598428778999, 24.75616416807159581, 53.187864361986541439, 59.885650741305887834, 50.869718765315795395, 33.937408346666828152, -11.183710253030254123, -24.915327929079072788, -57.153704082692499355, 15.011063202121658122}};

    float y1_step1_ymin = -1;
    float y1_step1_gain[6] = {0.100012971486658, 0.100022047084771, 0.0742758557193031, 0.125012688004324, 0.125014564453745, 0.125028908483616};
    float y1_step1_xoffset[6] = {-9.9976019367443, -9.99842405506194, 35.0726196369584, -7.99841187150792, -7.99884065303357, -7.99961824099214};

    // Simulation
    int Q = 1; // Number of samples

    // Input 1
    // 输入length归一化 mapminmax_apply
    float xp1[6]; // 归一化输入
    for (int i = 0; i < 6; i++)
    {
        xp1[i] = (x[i] - x1_step1_xoffset[i]) * x1_step1_gain[i] + x1_step1_ymin;
    }
    // 到此没有问题

    // Layer 1
    // tansig_apply
    float a1[10]; // 第一层输出
    for (int i = 0; i < 10; i++)
    {
        float sum = b1[i];
        for (int j = 0; j < 6; j++)
        {
            sum += IW1_1[i][j] * xp1[j];
        }
        a1[i] = 2.0 / (1.0 + exp(-2.0 * sum)) - 1.0;
    }
    // 输出a1的值是正确的

    // Layer 2 and output
    // 第二层输出并进行反归一化 mapminmax_reverse
    // float a2[6];    // 第二层输出y
    for (int i = 0; i < 6; i++)
    {
        float sum = b2[i];
        for (int j = 0; j < 10; j++)
        {
            sum += LW2_1[i][j] * a1[j];
        }
        y[i] = (sum - y1_step1_ymin) / y1_step1_gain[i] + y1_step1_xoffset[i];
    }
}