From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Wed, 28 Oct 2015 14:56:42 -0400
Subject: [Ocfs2-devel] [PATCH v3 3/7] selinux: Get rid of
	file_path_has_perm
In-Reply-To: <5631068B.3060803@tycho.nsa.gov>
References: <1445894128-6765-1-git-send-email-agruenba@redhat.com>
	<1445894128-6765-4-git-send-email-agruenba@redhat.com>
	<562FA8ED.7020704@tycho.nsa.gov>
	<CAHc6FU5w6Znxs=xa6TPgG0QJkAsx3=AwUn4KXNAiHMDQ1PsV2A@mail.gmail.com>
	<5631068B.3060803@tycho.nsa.gov>
Message-ID: <56311A6A.3080107@tycho.nsa.gov>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: LSM <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, ocfs2-devel@oss.oracle.com, David Howells <dhowells@redhat.com>

On 10/28/2015 01:31 PM, Stephen Smalley wrote:
> On 10/28/2015 07:48 AM, Andreas Gruenbacher wrote:
>> On Tue, Oct 27, 2015 at 5:40 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>>> On 10/26/2015 05:15 PM, Andreas Gruenbacher wrote:
>>>>
>>>> Use path_has_perm directly instead.
>>>
>>>
>>> This reverts:
>>>
>>> commit 13f8e9810bff12d01807b6f92329111f45218235
>>> Author: David Howells <dhowells@redhat.com>
>>> Date:   Thu Jun 13 23:37:55 2013 +0100
>>>
>>>      SELinux: Institute file_path_has_perm()
>>>
>>>      Create a file_path_has_perm() function that is like path_has_perm() but
>>>      instead takes a file struct that is the source of both the path and the
>>>      inode (rather than getting the inode from the dentry in the path).  This
>>>      is then used where appropriate.
>>>
>>>      This will be useful for situations like unionmount where it will be
>>>      possible to have an apparently-negative dentry (eg. a fallthrough) that
>>> is
>>>      open with the file struct pointing to an inode on the lower fs.
>>>
>>>      Signed-off-by: David Howells <dhowells@redhat.com>
>>>      Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>>>
>>> which I think David was intending to use as part of his SELinux/overlayfs
>>> support.
>>
>> Okay. As long as overlayfs support in SELinux is in half-finished
>> state, let's leave this alone.
>
> Also, the caller is holding a spinlock (tty_files_lock), so you can't call inode_doinit from
> here.
>
> Try stress testing your patch series by just always setting isec->initialized to LABEL_INVALID.
> Previously the *has_perm functions could be called under essentially any condition, with the exception
> of when in a RCU walk and needing to audit the dname (but they did not previously block/sleep).

file_has_perm() also gets called from match_file() callback to 
iterate_fd(), which holds files->file_lock.
