From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Feb 2010 11:21:50 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add current->comm in trace output
In-Reply-To: <20100217042908.GA13798@mail.oracle.com>
References: <1266012546-13865-1-git-send-email-sunil.mushran@oracle.com>
	<20100217042908.GA13798@mail.oracle.com>
Message-ID: <4B7C41CE.2020507@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Fri, Feb 12, 2010 at 02:09:06PM -0800, Sunil Mushran wrote:
>   
>> Add current->comm to the standard mlog() output to help with debugging.
>>
>> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
>>     
> 	Do you have sample output?  This could get long, no?

It is a bit longer. But it is much more readable.

(thisisalongname,16751,0):ocfs2_dec_holders:788 ENTRY:
(thisisalongname,16751,0):ocfs2_dec_holders:804 EXIT
(thisisalongname,16751,0):ocfs2_downconvert_on_unlock:1970 ENTRY:
(thisisalongname,16751,0):ocfs2_downconvert_on_unlock:1993 EXIT
(thisisalongname,16751,0):__ocfs2_cluster_unlock:1540 EXIT
(thisisalongname,16751,0):ocfs2_inode_unlock:2493 EXIT
(thisisalongname,16751,0):ocfs2_readdir:2056 EXIT: 0
(thisisalongname,16751,0):ocfs2_drop_lock:3202 EXIT: 0
(thisisalongname,16751,0):ocfs2_lock_res_free:734 ENTRY:
(thisisalongname,16751,0):ocfs2_lock_res_free:761 EXIT
(kjournald2,16039,1):ocfs2_bmap:499 ENTRY:(block = 117)
(kjournald2,16039,1):ocfs2_bmap:533 EXIT: 33493
(kjournald2,16039,1):ocfs2_bmap:499 ENTRY:(block = 118)
(kjournald2,16039,1):ocfs2_bmap:533 EXIT: 33494
(kjournald2,16039,0):ocfs2_bmap:499 ENTRY:(block = 119)
(kjournald2,16039,0):ocfs2_bmap:533 EXIT: 33495


(o2net,16711,0):dlm_mle_release:429 ENTRY:
(o2net,16711,0):__dlm_lookup_lockres:219 
ENTRY:O00000000000000001f804400000000
(o2net,16711,0):__dlm_lookup_lockres_full:185 
ENTRY:O00000000000000001f804400000000
(o2net,16711,0):__dlm_lookup_lockres:219 
ENTRY:O00000000000000001f804400000000
(o2net,16711,0):__dlm_lookup_lockres_full:185 
ENTRY:O00000000000000001f804400000000
(o2net,16711,0):__dlm_lookup_lockres:219 
ENTRY:O00000000000000001f804400000000
(o2net,16711,0):__dlm_lookup_lockres_full:185 
ENTRY:O00000000000000001f804400000000
(o2net,16711,0):dlm_mle_release:429 ENTRY:
(o2net,16711,0):__dlm_lookup_lockres:219 ENTRY:N0000000000000041
(o2net,16711,0):__dlm_lookup_lockres_full:185 ENTRY:N0000000000000041
(o2net,16711,0):__dlm_lookup_lockres:219 ENTRY:N0000000000000041
(o2net,16711,0):__dlm_lookup_lockres_full:185 ENTRY:N0000000000000041
(o2net,16711,0):__dlm_lookup_lockres:219 ENTRY:N0000000000000041
(o2net,16711,0):__dlm_lookup_lockres_full:185 ENTRY:N0000000000000041
(o2net,16711,0):dlm_mle_release:429 ENTRY:

(o2net,10265,1):__dlm_lookup_lockres:219 ENTRY:N0000000000000041
(o2net,10265,1):__dlm_lookup_lockres_full:185 ENTRY:N0000000000000041
(o2net,10265,1):dlm_mle_release:429 ENTRY:
(events/0,14,0):ocfs2_inc_holders:782 EXIT
(events/0,14,0):__ocfs2_cluster_lock:1509 EXIT: 0
(events/0,14,0):__ocfs2_cluster_unlock:1531 ENTRY:
(events/0,14,0):ocfs2_dec_holders:788 ENTRY:
(events/0,14,0):ocfs2_dec_holders:804 EXIT
(events/0,14,0):ocfs2_downconvert_on_unlock:1970 ENTRY:
(events/0,14,0):ocfs2_downconvert_on_unlock:1993 EXIT
(events/0,14,0):__ocfs2_cluster_unlock:1540 EXIT
(o2net,10265,1):__dlm_lookup_lockres:219 
ENTRY:M00000000000000001f802800000000
(o2net,10265,1):__dlm_lookup_lockres_full:185 
ENTRY:M00000000000000001f802800000000
(o2net,10265,1):__dlm_lookup_lockres:219 
ENTRY:M00000000000000001f802800000000

(dlm_thread,16883,3):dlm_lockres_calc_usage:146 
ENTRY:P000000000000000000000000000000
(dlm_thread,16883,3):__dlm_lockres_calc_usage:118 
ENTRY:P000000000000000000000000000000
(dlm_thread,16883,3):dlm_do_local_bast:255 ENTRY:
(dlm_thread,16883,3):ocfs2_blocking_ast:1066 ERROR: BAST fired for 
lockres P000000000000000000000000000000, blocking 5, level 5, type 
OrphanScan
(dlm_thread,16883,3):ocfs2_generic_handle_bast:921 ENTRY:
(dlm_thread,16883,3):ocfs2_generic_handle_bast:939 ERROR: lockres 
P000000000000000000000000000000, block 5, level 5, l_block 5, dwn 1
(dlm_thread,16883,3):ocfs2_generic_handle_bast:944 EXIT: 1
(dlm_thread,16883,3):ocfs2_schedule_blocked_lock:4058 ENTRY:
(dlm_thread,16883,3):ocfs2_schedule_blocked_lock:4081 EXIT
(ocfs2dc,16882,2):ocfs2_downconvert_thread_do_work:4089 ENTRY:
(ocfs2dc,16882,2):ocfs2_process_blocked_lock:4016 ENTRY:
(ocfs2dc,16882,2):ocfs2_process_blocked_lock:4021 ERROR: lockres 
P000000000000000000000000000000 blocked
(ocfs2dc,16882,2):ocfs2_unblock_lock:3420 ENTRY:
(ocfs2dc,16882,2):ocfs2_prepare_downconvert:3311 ERROR: lockres 
P000000000000000000000000000000, level 5 => 0, blocking 5
