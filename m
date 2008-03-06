From: Jan Kara <jack@suse.cz>
Date: Thu, 06 Mar 2008 11:51:11 -0000
Subject: [Ocfs2-devel] [PATCH] Dynamic lockres hash table
In-Reply-To: <47CEE95E.8020200@oracle.com>
References: <20080304102448.GB24335@duck.suse.cz> <47CE065F.6080707@oracle.com>
	<20080305182618.GA10416@duck.suse.cz> <47CEE95E.8020200@oracle.com>
Message-ID: <20080306115100.GA12532@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed 05-03-08 10:41:34, Sunil Mushran wrote:
> Jan Kara wrote:
>>   Actually, it's non-trivial to measure (differently than by profiling).
>> You cannot use standard time functions because they have too low 
>> resolution
>> - we are speaking about microseconds here...
>>   
> jiffies should have enough resolution.
  Not really. On SLES kernels HZ=250 and thus 1 jiffie tick is 4ms. That's
quite a lot - actually, my lockres statistics show that quite a lot of lock
operations get below 4 ms (i.e., time for that acquisition was counted as
0). I guess they are operations that don't require any network
communication...

>>   Definitely, they should have 16 or even 32 pages per mount.  With 500K
>> lockres, which is not so extreme on bigger FS, 16 pages mean hash chains 
>> of
>> average length 61 on x86_64. It is not ideal but I guess it should be
>> sufficient.
>
> Any objections to increasing the default to 32 pages for 1.4?
  32 pages is fine with me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
