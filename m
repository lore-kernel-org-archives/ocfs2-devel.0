From: Andrew Beekhof <abeekhof@suse.de>
Date: Sat Nov 18 02:35:14 2006
Subject: [Ocfs2-devel] Re: [patch 0/3] OCFS Configurable timeouts from
	userspace
In-Reply-To: <20061118073600.206222000@suse.de>
References: <20061118073600.206222000@suse.de>
Message-ID: <C312C009-09C5-4403-93BC-6054366EF788@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Apologies, quilt seems to have misplaced the comments at the top of  
each patch:

Patch 1:
From: Andrew Beekhof <abeekhof@suse.de>
Subject: OCFS2 - Expose struct o2nm_cluster

Subsequent patches (namely userspace heartbeat and configurable  
timeouts)
   require access to the o2nm_cluster struct.  This patch does the
   necessary shuffling.

Patch 2:
From: Jeff Mahoney <jeffm@suse.de>
Subject: OCFS2 Configurable timeouts

Allow configuration of OCFS2 timeouts from userspace via configfs

Patch 3:
From: Andrew Beekhof <abeekhof@suse.de>
Subject: OCFS2 Configurable timeouts - Protocol changes

Modify the OCFS2 handshake to ensure essential timeouts are configured
   identically on all nodes.
Included is the field for userspace-heartbeat timeout to avoid the  
need for
   further protocol changes.

The addition of two dummy fields is a temporary measure to
    satisfy the logic in o2net_check_handshake() and will be
    rectified in a future version of this patch


On Nov 18, 2006, at 8:36 AM, abeekhof@suse.de wrote:

> --
>
> Jeff has asked me to finish off his configurable timeouts patch....
> here's the results :-)
>
> One thing I'm not so happy about are the changes (I made) to  
> o2net_msg struct
> in order to satisfy the logic in o2net_check_handshake()
>
> Presumably the logic in o2net_check_handshake() should be changed?
>
> Andrew

--
Andrew Beekhof

"Would the last person to leave please turn out the enlightenment?" -  
TISM
