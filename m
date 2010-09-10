From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 10 Sep 2010 09:22:36 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Handle empty list in
 lockres_seq_start() for dlmdebug.c
In-Reply-To: <1284084993-7767-1-git-send-email-tristan.ye@oracle.com>
References: <1284084993-7767-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100910162236.GE17223@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 10, 2010 at 10:16:33AM +0800, Tristan Ye wrote:
> This patch tries to handle the case in which list 'dlm->tracking_list' is
> empty, to avoid accessing an invalid pointer. It fixes the following oops:
> 
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1287
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"The first requisite of a good citizen in this republic of ours
 is that he shall be able and willing to pull his weight."
	- Theodore Roosevelt

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
