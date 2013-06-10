From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 10 Jun 2013 07:11:43 -0500
Subject: [Ocfs2-devel] unlink: why does try_open_lock fail on directory
 but works for a file?
In-Reply-To: <51B5A5E2.3020504@huawei.com>
References: <CAJtY7HUogDHLQbH0YNdk_UFuu6sJ8SmKTKjx4-0cR5LwMSczLQ@mail.gmail.com>
	<51B5A5E2.3020504@huawei.com>
Message-ID: <CAJtY7HWQmBkZAhcAU3z3zcnDn6ZKdSWpt3WTYUPfSK+K194Ugw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 10, 2013 at 5:09 AM, shencanquan <shencanquan@huawei.com> wrote:
> On 2013/6/8 22:34, Goldwyn Rodrigues wrote:
>>
>> Hi,
>>
>> I am trying to understand why the unlinks (distributed) are slow with
>> ocfs2. My investigation so far has revealed that ocfs2_try_open_lock
>> fails on the directory unlinked but works for a file unlinked. This
>> creates a checkpoint everytime a directory is deleted.. slowing
>> transactions following it.
>>
>> To explain the problem, consider the following scenario:
>>
>> On node A, I create multiple directories say d1-d8, and each have 3
>> files under it f1, f2 and f3.
>> On node B, I delete all directories using rm -Rf d*
>>
>> The FS first unlinks f1, f2 and f3. However, when it performs
>> ocfs2_evict_inode() ->  ocfs2_delete_inode() ->
>> ocfs2_query_inode_wipe() ->  ocfs2_try_open_lock() on d1, it fails.
>
>  on directory d1 it fail to call ocfs2_try_open_lock, it mean other node has
> lock the open lock. it maybe node A has open the directory d1?

This is a self-fabricated test and I just created the directory using
mkdir and files using touch Yes, it is possible that the PR open lock
is still on the directory.

>
>> This starts a checkpoint because OCFS2_INODE_DELETED flag is not set
>> on the directory inode.
>>
>> Now, a checkpoint interferes with the journaling of the inodes deleted
>> in the following unlinks, in our case, directories d2-d8 and the files
>> contained in it.
>>
>> So why do the files get the open_lock but the directories don't?
>
>   I don't think that the directory don't use the open_lock, otherwise it
> will be success to call the ocfs2_try_open_lock.

Do you mean to say directories don't use open_lock. Could you provide
the code/design reference?
