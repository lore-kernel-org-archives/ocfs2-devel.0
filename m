From: Wim Coekaerts <wim.coekaerts@oracle.com>
Date: Tue Jul  6 22:10:12 2004
Subject: [Ocfs2-devel] [PATCH] add notify trunctpage to close file
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8404D1BE82@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F8404D1BE82@pdsmsx403>
Message-ID: <20040707031008.GA5951@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

>  	ocfs_sync_inode(inode);

euhm I think we should not be doing a sync inode on every file release.
could explain the perofmrance degradation on install/untar
