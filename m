From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Sep 2010 15:25:24 -0700
Subject: [Ocfs2-devel] [PATCH 09/20] ocfs2/cluster: Print messages when
 adding/removing nodes and heartbeat regions
In-Reply-To: <1284504656-2434-10-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
	<1284504656-2434-10-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100923222524.GC803@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 14, 2010 at 03:50:45PM -0700, Sunil Mushran wrote:
> Prints messages when the user adds or removes nodes and heartbeat regions.
> The heartbeat region logging is only enabled in the global heartbeat mode. These
> messages are useful when debugging cluster related issues.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	I gotta say NAK.  Maybe Mark disagrees, but it certainly sounds
like we're spamming the log for things that are normally not terribly
interesting.
	If you're worried about tracking registration of nodes, have
the o2cb tool syslog it.  That will get logged, but won't pollute dmesg.

Joel

-- 

"Baby, even the losers
 Get luck sometimes.
 Even the losers
 Keep a little bit of pride."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
