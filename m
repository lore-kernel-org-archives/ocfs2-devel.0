From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 5 Mar 2009 18:36:32 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: reserve xattr block for new
	directory with	inline data
In-Reply-To: <1236305970-3940-1-git-send-email-tiger.yang@oracle.com>
References: <20090305233027.GB27682@mail.oracle.com>
	<1236305970-3940-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20090306023632.GA28795@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 06, 2009 at 10:19:30AM +0800, Tiger Yang wrote:
> If this is a new directory with inline data, we choose to
> reserve the entire inline area for directory contents and
> force an external xattr block.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Acked-by: Joel Becker <joel.becker@oracle.com>


-- 

"To fall in love is to create a religion that has a fallible god."
        -Jorge Luis Borges

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
