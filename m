From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Sep 2010 14:23:07 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Use cpu_to_le16 for
 e_leaf_clusters in ocfs2_bg_discontig_add_extent.
In-Reply-To: <1284362030-3398-1-git-send-email-tao.ma@oracle.com>
References: <20100913062907.GA16449@mail.oracle.com>
	<1284362030-3398-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100923212307.GB6609@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Sep 13, 2010 at 03:13:50PM +0800, Tao Ma wrote:
> e_leaf_clusters is a le16, so use cpu_to_le16 instead
> of cpu_to_le32.
> 
> What's more, we change 'clusters' to unsigned int to
> signify that the size of 'clusters' isn't important here.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

        This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"The question of whether computers can think is just like the question
 of whether submarines can swim."
	- Edsger W. Dijkstra

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
