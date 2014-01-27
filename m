From: Xue jiufei <xuejiufei@huawei.com>
Date: Mon, 27 Jan 2014 10:58:56 +0800
Subject: [Ocfs2-devel] Doubt about the behavior of filemap_fdatawrite
In-Reply-To: <20140126181813.1ad3a4d9.akpm@linux-foundation.org>
References: <52E26AAE.1070701@huawei.com>	<20140124171621.62f40f67.akpm@linux-foundation.org>	<52E5BC3F.7020404@huawei.com>
	<20140126181813.1ad3a4d9.akpm@linux-foundation.org>
Message-ID: <52E5CB70.1080807@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/1/27 10:18, Andrew Morton wrote:
> On Mon, 27 Jan 2014 09:54:07 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:
> 
>> On 2014/1/25 9:16, Andrew Morton wrote:
>>> On Fri, 24 Jan 2014 21:29:18 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:
>>>
>>>> Hi Andrew,
>>>> Currently filemap_fdatawrite scans the page range and tags all pages
>>>> that have DIRTY tag, and then sets with a special TOWRITE tag. Then it
>>>> will clear a page's DIRTY tag after submit bh.
>>>
>>> It should clear PG_Dirty *before* starting the IO.
>>>
>>>> Here if disk or iSCSI link is down, EIO returns. Now I want to retry it
>>>> by calling filemap_fdatawrite again because the disk or link may
>>>> recover. Since the DIRTY tag is already cleaned before, I would not be
>>>> able to do so.
>>>> So I have doubt about if I can revert to the DIRTY tag in such a case?
>>>> Thanks very much for you time.
>>>
>>> No, the data is lost.  If we were to retain the dirty bit then a dead
>>> disk drive could take down the whole machine by creating permanently
>>> used and unreclaimable pagecache.
>>>
>> What do you mean for "data is lost"?
> 
> The page is marked clean then we try to write it.  If that write fails,
> the page remains clean and will be reclaimed.
> 
>> To revert the DIRTY tag only when EIO returns and I will increase page
>> count to avoid page release.
> 
> What does "I will" mean?  Are you referring to existing code?  Or to
> some unseen kernel patch?  Please be more detailed and specific.
> 
>> Then I will retry filemap_fdatawrite till
>> disk recovers or timeout. At last, the DIRTY flag will be cleared.
> 
> I think perhaps this could be made to work.  If the device does not
> recover after a certain timeout or after a certain number of retries
> then leave the pages clean and permit them to be reclaimed (ie: lose the
> data).
> 
> But this makes me wonder: why redirty the page?  Why not just keep
> retrying the IO within the context of the initial ->wrietpage()?  If
> the driver can recover and write the page then fine.  If it cannot do
> that, then -EIO and the data is lost.
> 
In jbd2 order mode, it calls filemap_fdatawrite() to write data first,
and we want to retry the IO when it returns error.
->writepage() only submits bio without wait(async), it is not able to
retry the IO based on return code of writepage(). 
> 
> 
> Anyway, we should not be discussing this via private email - avoiding
> the mailing list(s) cuts many people out of the discussion and means
> that we'll end up repeating ourselves if any patch is forthcoming.
> 
> .
> 
