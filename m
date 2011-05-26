From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 26 May 2011 09:21:45 -0700
Subject: [Ocfs2-devel] [PATCH 0/4] ocfs2: bugfix for hard readonly mount
In-Reply-To: <4DDE7CF5.1020101@oracle.com>
References: <4DDE2000.3000301@oracle.com> <4DDE79EB.3080006@oracle.com>
	<4DDE7CF5.1020101@oracle.com>
Message-ID: <4DDE7E19.6090307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/26/2011 09:16 AM, Tristan Ye wrote:
> On 05/27/2011 12:03 AM, Sunil Mushran wrote:
>> Tiger, Thanks. Was this tested with all fs-features enabled? I am
>> worried about quotas. If not, please test that.
>>
>> Tristan, Please can you cross check these patches. Enable all features
>> in a volume, make it readonly and do mount, ls -lR, umount, read, stat,
>> stat -f. This calls for a test script. We should be able to use loopback.
>> losetup -rf.
>
> Sure,
>
> I'm going to write a dedicated script for sanity check, including these
> generic fs syscalls.

Thanks Tristan.

Tiger, I would suggest you roll up the patch into one. I see no reason
for the breakup considering it fixes just one bug and is small enough.
