From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Mar  5 11:22:48 2008
Subject: [Ocfs2-devel] [PATCH 10/12] ocfs2/dlm: Dumps the workqueue	into
	a debugfs file
In-Reply-To: <20080305191159.GI799@ca-server1.us.oracle.com>
References: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
	<1204678200-26237-11-git-send-email-sunil.mushran@oracle.com>
	<20080305191159.GI799@ca-server1.us.oracle.com>
Message-ID: <47CEF2FB.7080104@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yeah... I'll remove this patch. Not that we've ever used this
except that one time.

Joel Becker wrote:
> On Tue, Mar 04, 2008 at 04:49:58PM -0800, Sunil Mushran wrote:
>   
>> This patch dumps all the tasks on the workqueue it can fit in one page
>> into a debugfs file. Useful for debugging.
>>     
>  
>   
>> +void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data);
>> +void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data);
>> +void dlm_assert_master_worker(struct dlm_work_item *item, void *data);
>>     
> <snip>
>   
>> +		if (wi->func == dlm_request_all_locks_worker) {
>> +			out += snprintf(db->buf + out, db->len - out,
>> +					"RequestAllLocks, "
>> +					"recomaster=%d, deadnode=%d\n",
>> +					wi->u.ral.reco_master,
>> +					wi->u.ral.dead_node);
>> +		} else if (wi->func == dlm_mig_lockres_worker) {
>>     
>
> 	There *has* to be a better way to determine what kind of worker
> we have.  De-staticing functions just to compare them is pretty heavy
> handed.
>
> Joel
>
>   
