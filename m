From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Mar 18 12:50:35 2004
Subject: [Ocfs2-devel] A patch to fix bug 45 in bugzilla
In-Reply-To: <40596BF0.8020807@intel.com>
References: <40596BF0.8020807@intel.com>
Message-ID: <20040318185031.GO20057@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 18, 2004 at 05:29:20PM +0800, Sonic Zhang wrote:
> Hi,
> 
> I think I found the root cause of the bug 45 in the bugzilla.
> 
> Actually, it is not an OCFS bug. It is caused in the Linux journaling
> routine(JBD) journal_create(). In kernel 2.6.x, buffer_head state
> BH_Uptodate is checked in mark_buffer_dirty(), while kernel 2.4.x
> doesn't do. If this state doesn't exist in the buffer_head, buffer error
> information is reported. But, in routine journal_create(), the state
> BH_Uptodate is set after the call to mark_buffer_dirty(). This works 
> well in kernel 2.4.x, but fails in kernel 2.6.x.
> 
> I attach a patch to fix this bug in kernel 2.6.x. Could you please put it 
> into the subfolder "patches" in ocfs2 source tree?
Cool! For some reason, this doesn't seem to patch against my 2.6.4 tree.
Would you mind regenerating it against a more recent 2.6 kernel? Also, you
should forward it to Stephen Tweedie (sct@redhat.com), the JBD maintainer.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
