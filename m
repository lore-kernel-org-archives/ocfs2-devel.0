From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Fri Jun  4 00:53:33 2004
Subject: [Ocfs2-devel] RE: [Ocfs-devel] [Patch] for bug 81
Message-ID: <3ACA40606221794F80A5670F0AF15F84048AA57D@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

seems the fix is rollback in revision 1001=20

>-----Original Message-----
>From: khackel@ca2.us.oracle.com=20
>[mailto:khackel@ca2.us.oracle.com] On Behalf Of Kurt Hackel
>Sent: 2004=C4=EA6=D4=C22=C8=D5 14:09
>To: Ling, Xiaofeng
>Cc: ocfs-devel@oss.oracle.com
>Subject: Re: [Ocfs-devel] [Patch] for bug 81
>
>Thank you very much!  Committed to revision 969.
>-kurt
>
>On Wed, Jun 02, 2004 at 01:53:36PM +0800, Ling, Xiaofeng wrote:
>> Index: namei.c
>> =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- namei.c     (revision 968)
>> +++ namei.c     (working copy)
>> @@ -526,7 +526,7 @@
>>=20
>>         status =3D -EBUSY;
>>=20
>> -       if (!empty_dir(inode)) {
>> +       if ( S_ISDIR (inode->i_mode) && !empty_dir(inode)) {
>>                 LOG_TRACE_STR ("dentry is not empty, cannot delete");
>>                 goto bail;
>>         } else if (OCFS_I(inode)->open_hndl_cnt > 0) {
>>=20
>> bug 81 description:
>> Env:
>>   kernel 2.4.20
>>   Dell Pc P4-2.1 512M, 80G
>> Reproduce Step:
>> 1.load_ocfs2 and mount to /ocfs
>> 2. touch /ocfs/file
>> 3. rm /ocfs/file
>>=20
>> With error message
>> (10396) ERROR at dir.c, 253: bad directory (dir #36300288) - no data
>> block
>> _______________________________________________
>> Ocfs-devel mailing list
>> Ocfs-devel@oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs-devel
>
_______________________________________________
Ocfs-devel mailing list
Ocfs-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs-devel
