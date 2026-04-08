"""
Figure Generation Code for:
BMI-Adjusted Aspirin Dosing Does Not Overcome Pharmacokinetic and 
Pharmacodynamic Disadvantages in Obese Pregnant Women

Generates: Figures 2A, 2B, 3A, 3B (boxplot + jitter, 600 DPI TIFF)
Requires: matplotlib, seaborn, pandas, numpy
"""

import pandas as pd
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# NOTE: Raw data not included. Available from corresponding author.
# Expected CSV columns: group, bmi, sal_base, sal_fu, txb2_base, txb2_fu,
#                       uta_ri_base, uta_ri_fu, uta_pi_base, uta_pi_fu

def create_boxplot_jitter(data_dict, ylabel, title_letter, positions, 
                          colors, alphas, brackets, ylim, outfile):
    fig, ax = plt.subplots(figsize=(6, 5))
    bp = ax.boxplot(data_dict.values(), positions=positions, widths=0.6,
                    patch_artist=True, showfliers=False, zorder=2)
    
    for patch, color, alpha in zip(bp['boxes'], colors, alphas):
        patch.set_facecolor(color); patch.set_alpha(alpha)
        patch.set_edgecolor('black'); patch.set_linewidth(0.8)
    for el in ['whiskers', 'caps', 'medians']:
        for line in bp[el]:
            line.set_color('black'); line.set_linewidth(0.8)

    np.random.seed(42)
    for i, (label, vals) in enumerate(data_dict.items()):
        jitter = np.random.normal(0, 0.08, len(vals))
        ax.scatter(positions[i] + jitter, vals, alpha=0.6, s=25,
                   color=colors[i], edgecolors='black', linewidths=0.3, zorder=3)

    for x1, x2, y, h, p_text in brackets:
        ax.plot([x1, x1, x2, x2], [y, y+h, y+h, y], color='black', linewidth=0.8)
        ax.text((x1+x2)/2, y+h*1.3, p_text, ha='center', va='bottom', fontsize=9)

    ax.set_xticks(positions)
    ax.set_xticklabels(data_dict.keys(), fontsize=9)
    ax.set_ylabel(ylabel, fontsize=11)
    ax.set_title(title_letter, fontsize=14, fontweight='bold', loc='left')
    ax.spines['top'].set_visible(False); ax.spines['right'].set_visible(False)
    if ylim: ax.set_ylim(ylim)
    plt.tight_layout()
    plt.savefig(outfile, dpi=600, bbox_inches='tight')
    plt.close()
    print(f"Saved: {outfile}")


# Example usage (uncomment with actual data):
# data = pd.read_csv("data_anonymized.csv")
# g1 = data[data['group']==1]; g2 = data[data['group']==2]
# positions = [1, 2, 3.5, 4.5]
# colors = ['#4C72B0', '#4C72B0', '#DD8452', '#DD8452']
# alphas = [0.4, 0.8, 0.4, 0.8]
#
# # Figure 2A: Salicylate
# create_boxplot_jitter(
#     {'100mg\\nBaseline': g1['sal_base'], '100mg\\nFollow-up': g1['sal_fu'],
#      '150mg\\nBaseline': g2['sal_base'], '150mg\\nFollow-up': g2['sal_fu']},
#     'Serum Salicylate (µg/mL)', 'A', positions, colors, alphas,
#     [(1,2,3.3,0.03,'ns'), (3.5,4.5,3.3,0.03,'ns'),
#      (1,3.5,3.55,0.03,'p=0.023'), (2,4.5,3.75,0.03,'p<0.001')],
#     (1.2, 4.1), 'Figure2A.tiff')
