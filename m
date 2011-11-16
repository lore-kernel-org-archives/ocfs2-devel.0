From: Artur Baruchi <mail.baruchi@gmail.com>
Date: Wed, 16 Nov 2011 16:00:38 -0200
Subject: [Ocfs2-devel] vmstore option - mkfs
In-Reply-To: <4EC3F6B1.5030909@oracle.com>
References: <CAAiDW_RtwX9puJ7HRD=U6+Cn_Ket2EBeYM5+rohH6Ze1GF6oWQ@mail.gmail.com>
	<4EC3F237.8000707@oracle.com>
	<CAAiDW_TVHH7aZJ7Wtpg_LQhD7M1+Gn47sQW2XxqnEH4DUMVM5w@mail.gmail.com>
	<4EC3F6B1.5030909@oracle.com>
Message-ID: <CAAiDW_TyiVy7Ht+-qHD44HX9gS09r8jJR2QQhvpS7S+voPKeNw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

That's fine...

Using vmstore:
vegeta:~ # mkfs.ocfs2 -T vmstore -n /dev/drbd1
mkfs.ocfs2 1.4.3
Dry run
Filesystem Type of vmstore
Label:
Features: sparse backup-super unwritten inline-data
strict-journal-super metaecc xattr indexed-dirs refcount
Block size: 4096 (12 bits)
Cluster size: 131072 (17 bits)
Volume size: 16105472000 (122875 clusters) (3932000 blocks)
Cluster groups: 4 (tail covers 26107 clusters, rest cover 32256 clusters)
Extent allocator size: 8388608 (2 groups)
Journal size: 134217728
Node slots: 8

Default mkfs:
vegeta:~ # mkfs.ocfs2 -n /dev/drbd1
mkfs.ocfs2 1.4.3
Dry run
Label:
Features: sparse backup-super unwritten inline-data
strict-journal-super metaecc xattr indexed-dirs
Block size: 4096 (12 bits)
Cluster size: 4096 (12 bits)
Volume size: 16105598976 (3932031 clusters) (3932031 blocks)
Cluster groups: 122 (tail covers 29055 clusters, rest cover 32256 clusters)
Extent allocator size: 4194304 (1 groups)
Journal size: 100659200
Node slots: 8


Thanks for your help.

Att.
Artur Baruchi



On Wed, Nov 16, 2011 at 3:45 PM, Sunil Mushran <sunil.mushran@oracle.com> wrote:
> Yes. But this is just the features. It also selects the appropriate cluster
> size, block size,
> journal size, etc. All the params selected are printed by mkfs. You also
> have the option of
> running with the --dry-option to see the params.
>
> On 11/16/2011 09:41 AM, Artur Baruchi wrote:
>>
>> I just found this:
>>
>> + ? ? ? {OCFS2_FEATURE_COMPAT_BACKUP_SB | OCFS2_FEATURE_COMPAT_JBD2_SB,
>> + ? ? ? ?OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC |
>> + ? ? ? ?OCFS2_FEATURE_INCOMPAT_INLINE_DATA |
>> + ? ? ? ?OCFS2_FEATURE_INCOMPAT_XATTR |
>> + ? ? ? ?OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE,
>> + ? ? ? ?OCFS2_FEATURE_RO_COMPAT_UNWRITTEN}, ?/* FS_VMSTORE */
>>
>> These options are the ones that, when choosing for vmstore, are
>> enabled by default. Is this correct?
>>
>> Thanks.
>>
>> Att.
>> Artur Baruchi
>>
>>
>>
>> On Wed, Nov 16, 2011 at 3:26 PM, Sunil Mushran<sunil.mushran@oracle.com>
>> ?wrote:
>>>
>>> fstype is a handy way to format the volume with parameters that are
>>> thought
>>> to be useful for that use-case. The result of this is printed during
>>> format
>>> by
>>> way of the parameters selected. man mkfs.ocfs2 has a blurb about the
>>> features
>>> it enabled by default.
>>>
>>> On 11/16/2011 08:45 AM, Artur Baruchi wrote:
>>>>
>>>> Hi.
>>>>
>>>> I tried to find some information about the option vmstore when
>>>> formating a device, but didnt found anything about it (no
>>>> documentation, I did some greps inside the source code, but nothing
>>>> returned). My doubts about this:
>>>>
>>>> - What kind of optimization this option creates in my file system to
>>>> store vm images? I mean.. what does exactly this option do?
>>>> - Where, in source code, I can find the part that makes this
>>>> optimization?
>>>>
>>>> Thanks in advance.
>>>>
>>>> Att.
>>>> Artur Baruchi
>>>>
>>>
>
>
