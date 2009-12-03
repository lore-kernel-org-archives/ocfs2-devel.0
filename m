From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 2 Dec 2009 17:38:27 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster: Make fence method
 configurable - v2
In-Reply-To: <1258504159-19981-1-git-send-email-sunil.mushran@oracle.com>
References: <1258504159-19981-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091203013827.GE31647@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 17, 2009 at 04:29:19PM -0800, Sunil Mushran wrote:
> By default, o2cb fences the box by calling emergency_restart(). While this
> scheme works well in production, it comes in the way during testing as it
> does not let the tester take stack/core dumps for analysis.
> 
> This patch allows user to dynamically change the fence method to panic() by:
> # echo "panic" > /sys/kernel/config/cluster/<clustername>/fence_method
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	This is now in the merge-window branch of ocfs2.git

Joel

-- 

"Nothing is wrong with California that a rise in the ocean level
 wouldn't cure."
        - Ross MacDonald

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
