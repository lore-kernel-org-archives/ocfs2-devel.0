From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar 24 20:26:14 2004
Subject: [Ocfs2-devel] Patch to fix error if mount fails
In-Reply-To: <40608223.5020404@intel.com>
References: <40608223.5020404@intel.com>
Message-ID: <20040325022609.GK10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 23, 2004 at 10:29:55AM -0800, John L. Villalovos wrote:
> I had an issue where if the mount failed after the threads had started that 
> the thread would crash later on.
Do you have any more info on the crash? I'd be interested in what
the NM thread did to kill itself... Or is this that bug where one of the
devices fields on a bh was not set?
 
> This patch makes sure that the NM thread is terminated if the mount fails 
> and the thread has been started.
>
> I didn't really see an easy way to terminate the listener thread :(
Well, it's supposed to be happening in ocfs_dismount_volume, which *does*
get called if ocfs_mount_volume returns an error. Why isn't it happening
there? Is it because "osb->dlm_task" hasn't been set yet?
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
