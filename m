From: Coly Li <coly.li@suse.de>
Date: Fri, 31 Jul 2009 19:59:08 +0800
Subject: [Ocfs2-devel] lvb length issue [was Re: [ocfs2-tools-devel]
 question of ocfs2_controld (Jun 27)]
In-Reply-To: <20090709185338.GA11643@redhat.com>
References: <4A451AB5.9070908@suse.de> <20090626193436.GC4478@mail.oracle.com>
	<4A45257C.6040704@suse.de> <20090629080023.GB8373@mail.oracle.com>
	<4A51ED7F.2040105@suse.de> <20090707160113.GA9140@redhat.com>
	<20090707174741.GA24163@mail.oracle.com>
	<20090708141542.GA8778@redhat.com>
	<20090709185338.GA11643@redhat.com>
Message-ID: <4A72DC8C.303@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



David Teigland Wrote:
> On Wed, Jul 08, 2009 at 09:15:42AM -0500, David Teigland wrote:
>> On Tue, Jul 07, 2009 at 10:47:42AM -0700, Joel Becker wrote:
>>> 	In this case, it's userspace utilities locking to verify no one
>>> else is doing anything in the cluster.  coly has noticed mkfs.ocfs2, but
>>> tunefs.ocfs2 and fsck.ocfs2 do the same thing.
>>> 	While a 64byte user lvb would be ideal, I think a flag to work
>>> around it would be great.  If the flag says "I know this lockspace may
>>> have !32byte LVBs, but I promise not to use them", and you can error
>>> when someone tries to set/get LVBs in that case, I think it works.
> 
> Here's a kernel patch that I've not yet tried.  The code using libdlm will
> need to add the flag 0x00000010 to dlm_new_lockspace().  (Until we've added
> the new LVB64 define to libdlm.h.)
> 
> +#define DLM_LSFL_LVB64		0x00000010
>
Another difficulty is user space libdlm interface. Right now, the interface
mkfs.ocfs2 uses to create a lock space is,
dlm_lshandle_t dlm_create_lockspace(const char *name, mode_t mode)
{
        return create_lockspace(name, mode, 0);
}

There is no way to set flags in dlm_create_lockspace() and it is set to 0 inside
the interface.

Is it possible to export create_lockspace() and release_lockspace() from libdlm
? So ocfs2-tools can load these symbols with dlopen() and calls these routines
with flags (set DLM_LSFL_LVB64).

Other 2 options might be,
1) add flags in dlm_create_lockspace(), which will change libdlm api.
2) update default lvb length from 32bytes to 64bytes.

Thanks.
-- 
Coly Li
SuSE Labs
