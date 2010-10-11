From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 11 Oct 2010 10:32:31 -0500
Subject: [Ocfs2-devel] Question: recovery map vs replay map
In-Reply-To: <4CAF75EB.9050209@oracle.com>
References: <AANLkTik2S+-guvnhvUGXOBOD74Ph0gf68NgN9uMG5LyD@mail.gmail.com>
	<4CAF75EB.9050209@oracle.com>
Message-ID: <AANLkTimT3XGD+DZQk-7WrVEcZxfjTB2CrtnqoEWwT39v@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 8, 2010 at 2:50 PM, Sunil Mushran <sunil.mushran@oracle.com> wrote:
> On 10/08/2010 12:03 PM, Goldwyn Rodrigues wrote:
>>
>> I was reading through the recovery code and got confused with recovery
>> and replay maps.
>>
>> What is the function of recovery maps and replay maps? Is a replay map
>> generated for each entry in the recovery map? Is there a situation
>> where a replay map is created without a recovery map entry?
>>
>
> During recovery, we need to recover the slot used by the dead node
> (including journal replay) and clean up the unused orphaned inodes.
>
> The recovery map refers to the nodes whose slot needs recovery.
>
> The replay map (confusing name, in hindsight) refers to unused slots
> whose orphaned inodes need to be cleaned up.
>
> Consider the case of a 4 node cluster having nodes 0, 1, 2, 3.
> Say node 0 removes a file that is in-use on node 1. Node 0 will
> move the inode to its orphan directory. Then say it umounts.
> At this stage, say node 1 dies.
>
> One of the surviving nodes will recover the node 1's slot. That
> includes replaying its journal and cleaning up its orphan directory.
>
> But what about the orphan directory that node 0 used that has that
> inode that was in use on node 1. That needs to be cleaned up too.
>
> The replay map, populated with unused slots, will contain the slot
> used by node 0.


Thanks Sunil. This example clears a lot of doubts.


-- 
Goldwyn
