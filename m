From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 6 Jun 2011 14:57:39 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: free memory allocated by
	inode_init_security
In-Reply-To: <1306994676-14402-1-git-send-email-tiger.yang@oracle.com>
References: <1306994676-14402-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20110606215739.GC10985@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 02, 2011 at 02:04:36PM +0800, Tiger Yang wrote:
> The LSM security_inode_init_security() hook allocates memory
> for xattr name and value, expecting the caller to release
> the memory afterwards.
> 
> reported-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
