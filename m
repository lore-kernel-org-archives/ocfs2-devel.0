From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 11 Oct 2010 13:57:59 -0700
Subject: [Ocfs2-devel] [PATCH] Initialize max_slots early
In-Reply-To: <AANLkTinGe9j+NnKh9ftHH1po1ZSoaE_AiZ47q2v-+9cT@mail.gmail.com>
References: <AANLkTinGe9j+NnKh9ftHH1po1ZSoaE_AiZ47q2v-+9cT@mail.gmail.com>
Message-ID: <20101011205759.GG4255@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Oct 11, 2010 at 12:57:09PM -0500, Goldwyn Rodrigues wrote:
> Functions such as ocfs2_recovery_init() make use of osb->max_slots.
> Initialize osb->max_slots early so the functions may use the correct
> value.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

	This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #157 

	"Take time to smell the roses."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
