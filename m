From: Steven Whitehouse <swhiteho@redhat.com>
Date: Fri, 11 Oct 2019 11:14:31 +0100
Subject: [Ocfs2-devel] [Cluster-devel] Interest in DAX for OCFS2 and/or
	GFS2?
In-Reply-To: <CH2PR18MB3206F78AC614EAC963AF8203CF970@CH2PR18MB3206.namprd18.prod.outlook.com>
References: <AT5PR8401MB1025DFAE60F5A5A4BCC5D2038B940@AT5PR8401MB1025.NAMPRD84.PROD.OUTLOOK.COM>
	<CH2PR18MB3206F78AC614EAC963AF8203CF970@CH2PR18MB3206.namprd18.prod.outlook.com>
Message-ID: <8d0de038-9127-3a95-ab1d-e0ac2cc483de@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 11/10/2019 08:21, Gang He wrote:
> Hello hayes,
>
>> -----Original Message-----
>> From: cluster-devel-bounces at redhat.com
>> [mailto:cluster-devel-bounces at redhat.com] On Behalf Of Hayes, Bill
>> Sent: 2019?10?11? 0:42
>> To: ocfs2-devel at oss.oracle.com; cluster-devel at redhat.com
>> Cc: Rocky (The good-looking one) Craig <rocky.craig@hpe.com>
>> Subject: [Cluster-devel] Interest in DAX for OCFS2 and/or GFS2?
>>
>> We have been experimenting with distributed file systems across multiple
>> Linux instances connected to a shared block device.  In our setup, the "disk" is
>> not a legacy SAN or iSCSI.  Instead it is a shared memory-semantic fabric
>> that is being presented as a Linux block device.
>>
>> We have been working with both GFS2 and OCFS2 to evaluate the suitability
>> to work on our shared memory configuration.  Right now we have gotten
>> both GFS2 and OCFS2 to work with block driver but each file system still does
>> block copies.  Our goal is to extend mmap() of the file system(s) to allow true
>> zero-copy load/store access directly to the memory fabric.  We believe
>> adding DAX support into the OCFS2 and/or GFS2 is an expedient path to use a
>> block device that fronts our memory fabric with DAX.
>>
>> Based on the HW that OCFS2 and GFS2 were built for (iSCSI, FC, DRDB, etc)
>> there probably has been no reason to implement DAX to date.  The advent of
>> various memory semantic fabrics (Gen-Z, NUMAlink, etc) is driving our
>> interest in extending OCFS2 and/or GFS2 to take advantage of DAX.  We
>> have two platforms set up, one based on actual hardware and another based
>> on VMs and are eager to begin deeper work.
>>
>> Has there been any discussion or interest in DAX support in OCFS2?
> No, but I think this is very interesting topic/feature.
> I hope we can take some efforts in investigating how to make OCFS2 support DAX, since some local file systems have supported this feature for long time.

Well, I think it is more accurate to say that the feature has been 
evolving in local filesystems for some time. However, it is moving 
towards time where it makes sense to think about this for clustered 
filesystems, so this is a timely topic for discussion in that sense.


>> Is there interest from the OCFS2 development community to see DAX support
>> developed and put upstream?
> >From my personal view, it is very attractive.
> But we also aware cluster file systems are usually based on DLM, DLM usually communicates with each other via the network.
> That means network latency should be considered.
>
> Thanks
> Gang

Hopefully we can come up with a design which avoids the network latency, 
at least in most cases. With GFS2 direct_io for example, the locking is 
designed such that DLM lock requests are only needed in case of block 
allocation/deallocation. Extending the same concept to DAX should allow 
(after the initial page fault) true DSM via the filesystem. It may be 
able to do even better eventually, but that would be a good starting point.

It has not been something that the GFS2 developers have looked at in any 
detail recently, however it is something that would be interesting, and 
we'd be very happy for someone to work on this and send patches in due 
course,

Steve.


>
>> Has there been any discussion or interest in DAX support in GFS2?
>> Is there interest from the GFS2 development community to see DAX support
>> developed and put upstream?
>>
>> Regards,
>> Bill
>>
>
>
