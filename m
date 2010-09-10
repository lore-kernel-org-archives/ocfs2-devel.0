From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 10 Sep 2010 09:22:19 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Re-access the journal after
 ocfs2_insert_extent() in dxdir codes.
In-Reply-To: <1283937158-4763-1-git-send-email-tristan.ye@oracle.com>
References: <1283937158-4763-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100910162218.GD17223@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 08, 2010 at 05:12:38PM +0800, Tristan Ye wrote:
> In ocfs2_dx_dir_rebalance(), we need to rejournal_acess the blocks after
> calling ocfs2_insert_extent() since growing an extent tree may trigger
> ocfs2_extend_trans(), which makes previous journal_access meaningless.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #173

	"Be kinder than necessary."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
