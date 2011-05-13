From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 May 2011 19:35:38 -0700
Subject: [Ocfs2-devel] [PATCH] o2dlm: check lockres validity in
	createlock
In-Reply-To: <20110512085705.GA19435@laptop.jp.oracle.com>
References: <201105110448.p4B4mErr019249@acsmt357.oracle.com>
	<4DCAAD7C.6090007@oracle.com> <4DCADE48.6020101@oracle.com>
	<20110512085705.GA19435@laptop.jp.oracle.com>
Message-ID: <4DCC98FA.2060000@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/12/2011 01:57 AM, Wengang Wang wrote:
> On 11-05-11 12:06, Sunil Mushran wrote:
>> Oh a remote master. So ignore my previous reply.
>>
>> Yes, I can see the race. But the fix below lets the purge to continue
>> and handles it afterwards. A better approach (and more efficient)
>> would be to remove the lockres from the purge list itself.
>>
>> So the race window is between the first block in dlm_get_lock_resource()
>> and dlm_lock_remote().
>>
>> See dlm->inflight_locks. Currently we use this when lockres is locally
>> mastered. Maybe we could use the same for locally mastered too.
> Sunil,
>
> So the only purpose of inflight_locks is to prevent the lockres from
> being purged, right?
>
> I think only removing the lockres from the purge list is enough.
>
> If we hack on inflight_locks, we don't need to remove the lockres from purge list,
> right?

Yes. But you have to be careful. inflight_locks currently is used
to prevent a race in locally mastered resources. I think we can
use it for remotely mastered too.
