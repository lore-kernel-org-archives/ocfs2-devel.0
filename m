From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 21 Jan 2010 19:46:57 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: add extent block stealing for
	ocfs2
In-Reply-To: <20100120224319.GC4333@mail.oracle.com>
References: <> <1263635115-4930-1-git-send-email-tiger.yang@oracle.com>
	<4B542738.90003@oracle.com> <20100120224319.GC4333@mail.oracle.com>
Message-ID: <4B583EB1.1010504@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> 	Again, have to functions for stealing: ocfs2_steal_inode() and
> ocfs2_steal_meta().  You can have them call this version with a type
> field, but that should be hidden from the call sites.  You don't need
> "_from_other_nodes" in the name.
> 
> Joel
> 
Great thanks for your review. The new patch was delivered according to 
your comments.

Best regards,
tiger
