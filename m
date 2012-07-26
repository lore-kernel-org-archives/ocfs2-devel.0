From: Xiaowei <xiaowei.hu@oracle.com>
Date: Thu, 26 Jul 2012 14:52:17 +0800
Subject: [Ocfs2-devel] [PATCH] Fix waiting status race condition in dlm
 recovery
In-Reply-To: <CAEeiSHWkhD8x8nrix2+Wc1nesH8CExU6kA10nCH0J1nCwUaDtg@mail.gmail.com>
References: <1337925202-13086-1-git-send-email-xiaowei.hu@oracle.com>
	<CAEeiSHXcaKXi7Qm5vLBmTp2CjiB7DCrUee5qmr03YpuJbzP5yg@mail.gmail.com>
	<4FC56CA5.8040902@oracle.com>
	<CAEeiSHWkhD8x8nrix2+Wc1nesH8CExU6kA10nCH0J1nCwUaDtg@mail.gmail.com>
Message-ID: <5010E921.40808@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

I considered your suggestion about this patch, it's possible to change 
the status in dlm hb down event,
but what need to change are the dlm_reco_node_data structures in 
dlm->reco.node_data list.
This list is initialized in dlm_remaster_locks when it begins the lock 
remaster and destroied before exit this function.
So it's not proper to check data in such a list from dlm hb down event, 
am I right?
If change the status from dlm hb down event , that means we make the 
recovery thread rely on more information from the hb down event,
actually the dlm->live_nodes_map is marked in this event , and for 
others to check , right?

This race condition only happen when cluster already in recovery and a 
node dead during recovery. the recovery thread blocked the update of 
dlm->domain_map, so I fallback to check the live_nodes_map, which won't 
be blocked.

Please reconsider this patch.

Thanks,
Xiaowei

On 05/31/2012 09:18 AM, Sunil Mushran wrote:
> On Tue, May 29, 2012 at 5:41 PM, Xiaowei <xiaowei.hu@oracle.com> wrote:
>> On 05/30/2012 06:09 AM, Sunil Mushran wrote:
>> I would suggest exploring adding this in dlm hb down event. Checking live
>> map all
>> over the place is hacky. We do it more than we should right now. Let's not
>> add to the
>> mess.
>>
>> HI Sunil,
>>
>> Do you mean we should clear the bit in domain map in dlm hb down event
>> directly when the node down
>> and check with dlm_is_node_dead at here?
>> Or how could we explore and ensure the node is alive during the whole
>> migrate process?One node could die even after it sends out one locks package
>> and before the next if there were too many locks on that lockres.
> dlm hb down event is triggered when a node is declared dead. That's where we
> clean up pending mles, etc. You can add a check for recovery and add logic to
> change the reco state for that node there.
