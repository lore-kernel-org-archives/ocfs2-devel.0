From: Luis Chamberlain <mcgrof@kernel.org>
Date: Fri, 29 May 2020 07:40:55 +0000
Subject: [Ocfs2-devel] [PATCH 00/13] sysctl: spring cleaning
Message-ID: <20200529074108.16928-1-mcgrof@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: keescook@chromium.org, yzaikin@google.com, nixiaoming@huawei.com, ebiederm@xmission.com, axboe@kernel.dk, clemens@ladisch.de, arnd@arndb.de, gregkh@linuxfoundation.org, jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch, benh@kernel.crashing.org, rdna@fb.com, viro@zeniv.linux.org.uk, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, vbabka@suse.cz, sfr@canb.auug.org.au, jack@suse.cz, amir73il@gmail.com, rafael@kernel.org, tytso@mit.edu
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, julia.lawall@lip6.fr, Luis Chamberlain <mcgrof@kernel.org>, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com

Me and Xiaoming are working on some kernel/sysctl.c spring cleaning.
During a recent linux-next merge conflict it became clear that
the kitchen sink on kernel/sysctl.c creates too many conflicts,
and so we need to do away with stuffing everyone's knobs on this
one file.

This is part of that work. This is not expected to get merged yet, but
since our delta is pretty considerable at this point, we need to piece
meal this and collect reviews for what we have so far. This follows up
on some of his recent work.

This series focuses on a new helper to deal with subdirectories and
empty subdirectories. The terminology that we will embrace will be
that things like "fs", "kernel", "debug" are based directories, and
directories underneath this are subdirectories.

In this case, the cleanup ends up also trimming the amount of
code we have for sysctls.

If this seems reasonable we'll kdocify this a bit too.

This code has been boot tested without issues, and I'm letting 0day do
its thing to test against many kconfig builds. If you however spot
any issues please let us know.

Luis Chamberlain (9):
  sysctl: add new register_sysctl_subdir() helper
  cdrom: use new sysctl subdir helper register_sysctl_subdir()
  hpet: use new sysctl subdir helper register_sysctl_subdir()
  i915: use new sysctl subdir helper register_sysctl_subdir()
  macintosh/mac_hid.c: use new sysctl subdir helper
    register_sysctl_subdir()
  ocfs2: use new sysctl subdir helper register_sysctl_subdir()
  test_sysctl: use new sysctl subdir helper register_sysctl_subdir()
  sysctl: add helper to register empty subdir
  fs: move binfmt_misc sysctl to its own file

Xiaoming Ni (4):
  inotify: simplify sysctl declaration with register_sysctl_subdir()
  firmware_loader: simplify sysctl declaration with
    register_sysctl_subdir()
  eventpoll: simplify sysctl declaration with register_sysctl_subdir()
  random: simplify sysctl declaration with register_sysctl_subdir()

 drivers/base/firmware_loader/fallback.c       |  4 +
 drivers/base/firmware_loader/fallback.h       | 11 +++
 drivers/base/firmware_loader/fallback_table.c | 22 ++++-
 drivers/cdrom/cdrom.c                         | 23 +----
 drivers/char/hpet.c                           | 22 +----
 drivers/char/random.c                         | 14 +++-
 drivers/gpu/drm/i915/i915_perf.c              | 22 +----
 drivers/macintosh/mac_hid.c                   | 25 +-----
 fs/binfmt_misc.c                              |  1 +
 fs/eventpoll.c                                | 10 ++-
 fs/notify/inotify/inotify_user.c              | 11 ++-
 fs/ocfs2/stackglue.c                          | 27 +-----
 include/linux/inotify.h                       |  3 -
 include/linux/poll.h                          |  2 -
 include/linux/sysctl.h                        | 21 ++++-
 kernel/sysctl.c                               | 84 +++++++++++--------
 lib/test_sysctl.c                             | 23 +----
 17 files changed, 144 insertions(+), 181 deletions(-)

-- 
2.26.2
