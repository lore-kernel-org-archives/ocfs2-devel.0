From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 31 Mar 2010 20:42:39 -0700
Subject: [Ocfs2-devel] [PATCH 14/15] ocfs2: Free block to the right
	block group.
In-Reply-To: <1270090752-18935-14-git-send-email-tao.ma@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
	<1270090752-18935-14-git-send-email-tao.ma@oracle.com>
Message-ID: <20100401034239.GK28680@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 01, 2010 at 10:59:11AM +0800, Tao Ma wrote:
> In case the block we are going to free is allocated from
> a discontiguous block group, we have to use suballoc_loc
> to be the right group.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	Boy, this was easier than I expected it to be.

Joel

-- 

 The zen have a saying:
 "When you learn how to listen, ANYONE can be your teacher."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
