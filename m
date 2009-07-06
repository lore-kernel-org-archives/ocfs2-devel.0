From: Coly Li <coly.li@suse.de>
Date: Mon, 06 Jul 2009 20:26:39 +0800
Subject: [Ocfs2-devel] lvb length issue [was Re: [ocfs2-tools-devel]
 question of ocfs2_controld (Jun 27)]
In-Reply-To: <20090629080023.GB8373@mail.oracle.com>
References: <4A451AB5.9070908@suse.de> <20090626193436.GC4478@mail.oracle.com>
	<4A45257C.6040704@suse.de> <20090629080023.GB8373@mail.oracle.com>
Message-ID: <4A51ED7F.2040105@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now the discussion moves to kernel space, I move the email from
ocfs2-tools-devel to ocfs2-devel.
The original discussion can be found from
http://oss.oracle.com/pipermail/ocfs2-tools-devel/2009-June/001891.html

Joel Becker Wrote:
> On Sat, Jun 27, 2009 at 03:46:04AM +0800, Coly Li wrote:
>> Joel Becker Wrote:
>>> On Sat, Jun 27, 2009 at 03:00:05AM +0800, Coly Li wrote:
>> [snip]
>>>> My original purpose is to find where to initiate a lvb with 64bytes, but from
>>>> mount.ocfs2 code, I don't find anywhere to create a dlm lockspace (before create
>>>> a lock) so far.
>>> 	I'm not sure why you need an LVB in mount.ocfs2, let alone a dlm
>>> lockspace.
>>>
>> Hi Joel,
>>
>> I don't need a LVB in mount code. My purpose is to find out where (k/u space)
>> creates a LVB with 64bytes length. The 64bytes LVB makes fs/dlm kernel code
>> returns an internal logic error (which should be a busy lock error) to
>> mkfs.ocfs2 when formating a mounted-by-other-node ocfs2 volume.
> 
> 	Can't fs/dlm take multiple LVB sizes?
> 
In this case, it cannot.

During mkfs.ocfs2, libdlm gets called to create a new lockspace via ioctl
handler inside fs/dlm, which (indeed) is fs/dlm/user.c:device_create_lockspace():
404 static int device_create_lockspace(struct dlm_lspace_params *params)
... ...
412
413  error = dlm_new_lockspace(params->name, strlen(params->name),
414                   &lockspace, params->flags, DLM_USER_LVB_LEN);
... ...
431 }
DLM_USER_LVB_LEN is defined to 32.

When mounting an ocfs2 volume, ocfs2 code calls dlm_new_lockspace directly.
Which is in fs/ocfs2/stack_user.c:user_cluster_connect():
814 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
815 {
... ...
842         rc = dlm_new_lockspace(conn->cc_name, strlen(conn->cc_name),
843                                &fsdlm, DLM_LSFL_FS, DLM_LVB_LEN);
... ...
853 }
DLM_LVB_LEN is 64.

When mkfs.ocfs2 tries to operate on a mounted-already ocfs2 volume, mkfs.ocfs2
calls libdlm routin and tries to create a lockspace with 32byte lvb length. The
lvb lengh is hard coded inside fs/dlm, can not be specified in user space.

When fs/dlm code tries to compare the 32bytes lvb to the 64bytes lvb which is
created in user_cluster_connect(), fs/dlm results an internal logic error(-EINVAL).

This error is misleading, if both sides use same length lvb, the returned error
can be busy domain(-EEXIST:), which is the correct one to be expected.

After checking the code of mkfs.ocfs2, mount.ocfs2, and libdlm, I don't find any
user space solution to fix the lvb length issue.

Therefore, I am locking for the possibility to use 32bytes lvb length for user
space stack. IMHO, the modification needs a ocfs2 protocol version update (for
nodes running different lvb length with user space stack), but fortunately does
not hurt on-disk format.

-- 
Coly Li
SuSE Labs
