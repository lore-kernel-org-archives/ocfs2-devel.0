From: Larry Chen <lchen@suse.com>
Date: Wed, 25 Oct 2017 10:08:04 +0800
Subject: [Ocfs2-devel] a puzzle about is_global_system_inode function
In-Reply-To: <SG2PR0601MB1871A4441C8C4AA3CF91EAB1D5470@SG2PR0601MB1871.apcprd06.prod.outlook.com>
References: <2061999c-f11b-b50d-55e4-09c847a5f25d@suse.com>
	<b6264a47-e86b-ecbc-2a11-9c26d6aa7812@gmail.com>
	<249f9d41-5666-1e35-919a-579ed0ec4273@suse.com>
	<SG2PR0601MB1871A4441C8C4AA3CF91EAB1D5470@SG2PR0601MB1871.apcprd06.prod.outlook.com>
Message-ID: <49751821-5de4-24dc-21e8-c8c3d6d4beeb@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi changwei, alex, and Joseph,

Really appreciate your help.

Thanks
Larry Chen

On 10/24/2017 9:16 PM, ge changwei wrote:
>
> On 24/10/2017 8:23 PM, Larry Chen wrote:
>> On 10/24/2017 7:04 PM, Joseph Qi wrote:
>>> GLOBAL_INODE_ALLOC_SYSTEM_INODE is used for system files inode
>>> allocation, you can refer to ocfs2-tools for details.
>> So it won't be used as an allocator after mkfs.ocfs2.? Is that true??
> Hi Larry,
> I think GLOBAL_INODE_ALLOC_SYSTEM_INODE system file is a reserved space
> for allocating inodes representing local allocater, etc.
>
> So there is no chance for us to modify it since it has no relation with
> file space allocation and declaim.
>
> So I suppose you are right, we won't use it anymore after mkfs until you
> have to tune it.
>
> Thanks?
> Changwei.
>
>> Thanks,
>> Larry Chen
>>
>>> Thanks,
>>> Joseph
>>>
>>> On 17/10/24 18:39, Larry Chen wrote:
>>>> Hi all,
>>>>
>>>> Function is_global_system_inode checks whether the type is
>>>> in the range [OCFS2_FIRST_ONLINE_SYSTEM_INODE ,
>>>> OCFS2_LAST_GLOBAL_SYSTEM_INODE ].
>>>> But why the range does not include GLOBAL_INODE_ALLOC_SYSTEM_INODE ??
>>>>
>>>> enum {
>>>>     ????? ....
>>>>     ?????? GLOBAL_INODE_ALLOC_SYSTEM_INODE,
>>>>     ??????? SLOT_MAP_SYSTEM_INODE,
>>>> #define OCFS2_FIRST_ONLINE_SYSTEM_INODE SLOT_MAP_SYSTEM_INODE
>>>>     ??????? HEARTBEAT_SYSTEM_INODE,
>>>>     ??????? GLOBAL_BITMAP_SYSTEM_INODE,
>>>>     ??????? USER_QUOTA_SYSTEM_INODE,
>>>>     ??????? GROUP_QUOTA_SYSTEM_INODE,
>>>> #define OCFS2_LAST_GLOBAL_SYSTEM_INODE GROUP_QUOTA_SYSTEM_INODE
>>>>     ??? ....
>>>> }
>>>>
>>>> Thanks
>>>> Larry Chen
>>>> _______________________________________________
>>>> Ocfs2-devel mailing list
>>>> Ocfs2-devel at oss.oracle.com
>>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
