From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Sat, 02 May 2015 07:45:17 -0500
Subject: [Ocfs2-devel] [RFC] Online File(system) check
In-Reply-To: <55408F6D.5020908@oracle.com>
References: <20150427213227.GA28129@shrek.lan> <55408F6D.5020908@oracle.com>
Message-ID: <5544C6DD.8000406@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 04/29/2015 02:59 AM, Junxiao Bi wrote:
> On 04/28/2015 05:32 AM, Goldwyn Rodrigues wrote:
>> On popular demand, here is an RFC. If you think there is a better
>> way to communicate with the kernel module for the check, please
>> let me know.
>>
>>
>> Intro
>> -----
>> OCFS2 is often used in high-availaibility systems. However, ocfs2
>> converts the filesystem to read-only at the drop of the hat. This
>> may not be necessary, since turning the filesystem read-only would
>> affect other running processes as well, decreasing availability.
>>
>> This attempt is to add errors=continue, which would return the EIO
>> to the calling process and terminate furhter processing so that
>> the filesystem is not corrupted further. However, the filesystem
>> is not converted to read-only.
> Is this safe, if detected an error when accessing an inode, how do you
> know this is only inode internal error?


Thanks for your comments. The error message would need to be modified to 
specify the inode(s) which need to be checked. It could be a regular 
file or the system inode.

> If there is corruptions in other
> place, the fs will be corrupted further.
>
It there is a corruption in another place, the process will err at that 
location.

Could you provide a sample case to explain this situation? and how is it 
different from what is already present in the code?

-- 
Goldwyn
