From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 11 Oct 2010 13:47:35 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: validate bg_free_bits_count after
 update
In-Reply-To: <1286319186-16697-1-git-send-email-srinivas.eeda@oracle.com>
References: <1286319186-16697-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20101011204735.GE4255@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 05, 2010 at 03:53:06PM -0700, Srinivas Eeda wrote:
> This patch adds a safe check to ensure bg_free_bits_count doesn't exceed
> bg_bits in a group descriptor. This is to avoid on disk corruption that was
> seen recently.
> 
> debugfs: group <52803072>
>        Group Chain: 179   Parent Inode: 11  Generation: 2959379682
>        CRC32: 00000000   ECC: 0000
>        ##   Block#            Total    Used     Free     Contig   Size
>        0    52803072          32256    4294965350   34202    18207    4032
>        ......
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>

	This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #252

	"Take good care of those you love."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
