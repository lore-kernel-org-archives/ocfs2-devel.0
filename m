From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 24 Jan 2014 14:00:51 -0800
Subject: [Ocfs2-devel] [patch 05/11] ocfs2: code cleanup: remove unused
	functions
In-Reply-To: <20140124204704.C07CA5A4203@corp2gmr1-2.hot.corp.google.com>
References: <20140124204704.C07CA5A4203@corp2gmr1-2.hot.corp.google.com>
Message-ID: <20140124220051.GD24361@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 24, 2014 at 12:47:04PM -0800, akpm at linux-foundation.org wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.de>
> Subject: ocfs2: code cleanup: remove unused functions
> 
> These functions are either coded in individual files as static or not used
> at all.  Remove them.

NAK - some of this may be used by userspace (ocfs2_fs.h is shared with
ocfs2-tools).

The other reason for my NAK is that some of these either complete a set of
functions or provide information on how to handle structures:
ocfs2_gd_is_discontig or ocfs2_system_inode_is_global are good examples and
it's all in ocfs2_fs.h which is where I'd personally go look to see how the
fs structures are stored.
	--Mark

--
Mark Fasheh
