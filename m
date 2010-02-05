From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 05 Feb 2010 09:18:13 +0800
Subject: [Ocfs2-devel] ocfs2: ei_cpos/phys confusion?
In-Reply-To: <4B65B58F.1010601@gmail.com>
References: <4B65B58F.1010601@gmail.com>
Message-ID: <4B6B71D5.8050405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Roel,

Roel Kluin wrote:
> in ocfs2_try_to_merge_extent_map(), vi fs/ocfs2/extent_map.c +185
> 
>         if (ins->ei_phys == (emi->ei_phys + emi->ei_clusters) &&
>             ins->ei_cpos == (emi->ei_cpos + emi->ei_clusters) &&
>             ins->ei_flags == emi->ei_flags) {
>                 emi->ei_clusters += ins->ei_clusters;
>                 return 1;
>         } else if ((ins->ei_phys + ins->ei_clusters) == emi->ei_phys &&
>                    (ins->ei_cpos + ins->ei_clusters) == emi->ei_phys &&
> ----------------------------------------------------------------^^^^
>                    ins->ei_flags == emi->ei_flags) {
>                 emi->ei_phys = ins->ei_phys;
>                 emi->ei_cpos = ins->ei_cpos;
>                 emi->ei_clusters += ins->ei_clusters;
>                 return 1;
>         }
> 
> should that 2nd emi->ei_phys be emi->ei_cpos?
oh, yes, you are right. Do you want to provide a patch?

Regards,
Tao
> 
> Roel
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
