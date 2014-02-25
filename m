From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 25 Feb 2014 12:03:43 -0800
Subject: [Ocfs2-devel] [PATCH 5/6] ocfs2: Avoid blocking in
 ocfs2_mark_lockres_freeing() in downconvert thread
In-Reply-To: <20140225191257.GJ5716@wotan.suse.de>
References: <1392975904-16944-1-git-send-email-jack@suse.cz>
	<1392975904-16944-6-git-send-email-jack@suse.cz>
	<20140225191257.GJ5716@wotan.suse.de>
Message-ID: <530CF71F.7080304@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 02/25/2014 11:12 AM, Mark Fasheh wrote:
> On Fri, Feb 21, 2014 at 10:45:03AM +0100, Jan Kara wrote:
>> If we are dropping last inode reference from downconvert thread, we will
>> end up calling ocfs2_mark_lockres_freeing() which can block if the lock
>> we are freeing is queued thus creating an A-A deadlock. Luckily, since
>> we are the downconvert thread, we can immediately dequeue the lock and
>> thus avoid waiting in this case.
>>
>> Signed-off-by: Jan Kara <jack@suse.cz>
> Latest version of this looks good, thanks Jan!
>
> Reviewed-by: Mark Fasheh <mfasheh@suse.de>
> 	--Mark
I didn't sent my reviewed by as akpm already queued this patch. But yes 
the new version looks good to me.

Reviewed-by: Srinivas Eeda<srinivas.eeda@oracle.com>

> --
> Mark Fasheh
