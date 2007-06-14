From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Jun 14 21:53:50 2007
Subject: [Ocfs2-devel] [PATCH 0/2] [RFC] configfs: Pin config_items when in
	use by other subsystems
Message-ID: <20070615044046.GA17382@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

	Many folks know that I've been pretty stubborn on the subject of
configfs item removal.  configfs_rmdir() cannot currently be aborted by
a client driver.  This is to ensure that userspace has control - if
userspace wants to remove an item, it should have that ability.  The
client driver is left to handle the event.
	However, there are dependencies in the kernel.  One kernel
subsystem may depend on a configfs item and be unable to handle that
item disappearing.  So we need a mechanism to describe this dependency.
After lots of beating me over my head, I've been convinced to give it a
shot.
	The canonical example is ocfs2 and its heartbeat.  Today, you
can stop o2cb heartbeat (o2hb) by rmdir(2) of the heartbeat object in
configfs.  o2hb handles this just fine - all of o2hb's clients get
node-down notifications.  However, ocfs2 can't handle this.  When the
node stops speaking to the cluster it can't just continue, and it can't
force an unmount of itself.  It only has one solution - crash.  This is
ugly any way you look at it.
	With the configfs_depend_item() API,
heartbeat_register_callback() can then pin the heartbeat item.  Any
rmdir(2) of the heartbeat item will return -EBUSY until
heartbeat_unregister_callback() removes the dependancy.  A similar API
can be created for any other configfs client driver.
	The first patch is the configfs mechanism.  The second patch is
the heartbeat use thereof.
	Comments and curses welcome.

Joel

-- 

"You must remember this:
 A kiss is just a kiss,
 A sigh is just a sigh.
 The fundamental rules apply
 As time goes by."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
