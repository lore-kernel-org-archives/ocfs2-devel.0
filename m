From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Mar 2015 15:16:10 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Neaten do_error,
 ocfs2_error and ocfs2_abort
In-Reply-To: <e05a1f6d65f0d6ff7f070f8dcb434129001986cf.1427425496.git.joe@perches.com>
References: <cover.1427425496.git.joe@perches.com>
	<e05a1f6d65f0d6ff7f070f8dcb434129001986cf.1427425496.git.joe@perches.com>
Message-ID: <20150327151610.bcc26d7577d35ce636d21833@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thu, 26 Mar 2015 20:07:08 -0700 Joe Perches <joe@perches.com> wrote:

> These uses sometimes do and sometimes don't have '\n' terminations.
> Make the uses consistently use '\n' terminations and remove the
> newline from the functions.

This is going to take a while to merge, as it's backed up behind a pile
of needs-more-reviewing ocfs2 patches.  Namely:

#ocfs2-trusted-xattr-missing-cap_sys_admin-check.patch: breaks userspace?
ocfs2-trusted-xattr-missing-cap_sys_admin-check.patch
#
ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch
#
add-errors=continue.patch
acknowledge-return-value-of-ocfs2_error.patch
clear-the-rest-of-the-buffers-on-error.patch
#
ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch
#
#ocfs2-use-64bit-variables-to-track-heartbeat-time.patch: acks?
ocfs2-use-64bit-variables-to-track-heartbeat-time.patch
#
#ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch: acks? Mark wants changes. Mark has list of notes
ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch
#
#ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch: acks? Mark has issues
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch
