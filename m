From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 10 Sep 2010 09:54:00 -0700
Subject: [Ocfs2-devel] [PATCH] Track negative entries v3
In-Reply-To: <AANLkTikSDWtoWOBEMf6gnhrjWo5eCBPHW9jqWKNF-6St@mail.gmail.com>
References: <AANLkTikSDWtoWOBEMf6gnhrjWo5eCBPHW9jqWKNF-6St@mail.gmail.com>
Message-ID: <20100910165400.GH885@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 28, 2010 at 10:04:32AM -0500, Goldwyn Rodrigues wrote:
> Track negative dentries by recording the generation number of the parent
> directory in d_fsdata. The generation number for the parent directory is
> recorded in the inode_info, which increments every time the lock on the
> directory is dropped.
> 
> If the generation number of the parent directory and the negative dentry
> matches, there is no need to perform the revalidate, else a revalidate
> is forced. This improves performance in situations where nodes look for
> the same non-existent file multiple times.
> 
> Thanks Mark for explaining the DLM sequence.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

	This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

"Not everything that can be counted counts, and not everything
 that counts can be counted."
        - Albert Einstein 

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
