From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 20 Mar 2015 09:17:12 +0800
Subject: [Ocfs2-devel] [PATCH 1/4 V2] ocfs2: use retval instead of
 status for checking error
In-Reply-To: <20150319152305.d4ff5c83744591ff9340db92@linux-foundation.org>
References: <20150227234840.GA12922@devel.8.8.4.4>
	<20150319152305.d4ff5c83744591ff9340db92@linux-foundation.org>
Message-ID: <550B7518.7000701@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daeseok Youn <daeseok.youn@gmail.com>, richard.weinberger@gmail.com, mfasheh@suse.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi Andrew,

On 2015/3/20 6:23, Andrew Morton wrote:
> On Sat, 28 Feb 2015 08:48:40 +0900 Daeseok Youn <daeseok.youn@gmail.com> wrote:
> 
>> The use of 'status' in __ocfs2_add_entry() can return wrong
>> status when some functions are failed.
>>
>> If ocfs2_journal_access_db() in __ocfs2_add_entry() is failed,
>> that status is saved to 'status' but return variable is 'retval'
>> which is saved 'success' status. In case of this,  __ocfs2_add_entry()
>> is failed but can be returned as 'success'.
>>
>> So replace 'status' with 'retval'.
>>
>> -						mlog_errno(status);
>> +					if (retval) {
>> +						mlog_errno(retval);
>>  						goto bail;
> 
> and
> 
> bail:
> 	if (retval)
> 		mlog_errno(retval);
> 
> 	return retval;
> }
> 
> so we'll clearly log the same error twice.
> 
IMO, if we only depends on the bail error log, we still don't know where
the error occurs.
So if we want to do the cleanup, the bail error log should be cleaned.

> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
