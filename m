From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 31 Jul 2008 13:41:59 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] Dynamic local alloc (halfway there)
Message-ID: <1217536922-28328-1-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patches against 2.6.26-rc1 implement the 1st part of dynamic
local alloc support - allowing the allocator to shrink, and re-enable itself
after being disabled. Growing the allocator beyond it's default will follow
soon, once I have time to complete the implementation and testing. In the
meantime, this series hopefully fixes at least one problem on long-running
tests where the local alloc file gets disabled.

Also included is a patch which adds a per-mountpoint debugfs file for
tracking local alloc state. More state will be added to that patch once
dynamic local alloc support is complete.
	--Mark
