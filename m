From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 9 Jul 2009 13:55:28 -0700
Subject: [Ocfs2-devel] lvb length issue [was Re: [ocfs2-tools-devel]
 question of ocfs2_controld (Jun 27)]
In-Reply-To: <20090709185338.GA11643@redhat.com>
References: <4A451AB5.9070908@suse.de> <20090626193436.GC4478@mail.oracle.com>
	<4A45257C.6040704@suse.de> <20090629080023.GB8373@mail.oracle.com>
	<4A51ED7F.2040105@suse.de> <20090707160113.GA9140@redhat.com>
	<20090707174741.GA24163@mail.oracle.com>
	<20090708141542.GA8778@redhat.com>
	<20090709185338.GA11643@redhat.com>
Message-ID: <20090709205528.GA30460@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 09, 2009 at 01:53:38PM -0500, David Teigland wrote:
> Here's a kernel patch that I've not yet tried.  The code using libdlm will
> need to add the flag 0x00000010 to dlm_new_lockspace().  (Until we've added
> the new LVB64 define to libdlm.h.)
> 
> >From 75e92c78bb0b0002f0253bfe10bef8585a0d52d6 Mon Sep 17 00:00:00 2001
> From: David Teigland <teigland@redhat.com>
> Date: Thu, 9 Jul 2009 13:11:02 -0500
> Subject: [PATCH] dlm: add DLM_LSFL_LVB64 for lockspace creation
> 
> Add a new flag DLM_LSFL_LVB64 to create lockspaces with 64 byte lvbs,
> overriding the lvb length parameter.  It is useful to override the
> fixed 32 byte lvb imposed by the user api when the lockspace is created
> from userspace but used from the kernel.  Locking through the user api
> can still only access 32 byte lvbs.

	Hmm, you're tying a permanent flag to 64bytes, yet userspace
can't get at them?  Seems a bit too ocfs2-tools specific, and yet it
doesn't let ocfs2-tools eventually try to share the lvb.

Joel

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
