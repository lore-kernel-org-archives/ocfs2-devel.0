From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 30 Jan 2009 14:22:04 -0800
Subject: [Ocfs2-devel] [PATCH 1/7] ocfs2: Introduce dir lookup helper
	struct
In-Reply-To: <1233351753-14640-2-git-send-email-mfasheh@suse.com>
References: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
	<1233351753-14640-2-git-send-email-mfasheh@suse.com>
Message-ID: <20090130222204.GB29626@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 30, 2009 at 01:42:27PM -0800, Mark Fasheh wrote:
> Many directory manipulation calls pass around a tuple of dirent, and it's
> containing buffer_head. Dir indexing has a bit more state, but instead of
> adding yet more arguments to functions, we introduce 'struct
> ocfs2_dir_lookup_result'. In this patch, it simply holds the same tuple, but
> future patches will add more state.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>

I really like this.

Signed-off-by: Joel Becker <joel.becker@oracle.com>

(I wish it didn't explode the stack of ocfs2_rename(), but, well, it's
rename).

-- 

Life's Little Instruction Book #306

	"Take a nap on Sunday afternoons."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
