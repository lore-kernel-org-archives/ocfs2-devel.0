From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 9 Jul 2009 17:50:35 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2-devel: trivial fix for
 s/migrate/migration/ in dlmrecovery.c, line 1121
In-Reply-To: <1246953100-8889-1-git-send-email-jeff.liu@oracle.com>
References: <>
 <1246953100-8889-1-git-send-email-jeff.liu@oracle.com>
Message-ID: <20090710005034.GA8522@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 07, 2009 at 03:51:40PM +0800, Jeff Liu wrote:
> in dlmrecovery.c:1121, replace 'migrate' to 'migration' to keep the consistency
> by comparing to other lines with the similar log info in the same file.
> 
> Signed-off-by: Jeff Liu <jeff.liu@oracle.com>

	This is now part of the fixes branch of ocfs2.git

Joel

-- 

"You can get more with a kind word and a gun than you can with
 a kind word alone."
         - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
