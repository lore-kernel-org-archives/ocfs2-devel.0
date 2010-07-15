From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 15 Jul 2010 14:02:51 -0700
Subject: [Ocfs2-devel] [PATCH v5] ocfs2: Don't duplicate page passes
 i_size during CoW.
In-Reply-To: <1279077572-9017-1-git-send-email-tao.ma@oracle.com>
References: <20100713183828.GA9468@mail.oracle.com>
	<1279077572-9017-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100715210250.GA29283@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 14, 2010 at 11:19:32AM +0800, Tao Ma wrote:
> During CoW, actually all the pages after i_size contains
> garbage data, so don't read and duplicate them.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"I don't know anything about music. In my line you don't have
 to."
        - Elvis Presley

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
