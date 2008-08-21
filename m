From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 20 Aug 2008 23:20:04 -0700
Subject: [Ocfs2-devel] [PATCH 05/10] ocfs2: Provide the get_root_el()
	method to	ocfs2_extent_tree_operations.
In-Reply-To: <48ACEA14.70104@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-6-git-send-email-joel.becker@oracle.com>
	<48ACEA14.70104@oracle.com>
Message-ID: <20080821062003.GC17607@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 12:07:48PM +0800, TaoMa wrote:
> Joel Becker wrote:
>> The root_el of an ocfs2_extent_tree needs to be calculated from
>> et->et_object.  Make it an operation on et->et_ops.
>>
>> Signed-off-by: Joel Becker <joel.becker@oracle.com>
>>
>>   static void ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
>> @@ -232,22 +260,16 @@ static void ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
>>  	et->et_object = obj;
>>   	if (et_type == OCFS2_DINODE_EXTENT) {
>> -		et->et_root_el =
>> -			&((struct ocfs2_dinode *)obj)->id2.i_list;
>>  		et->et_ops = &ocfs2_dinode_et_ops;
>>  	} else if (et_type == OCFS2_XATTR_VALUE_EXTENT) {
>> -		struct ocfs2_xattr_value_root *xv =
>> -			(struct ocfs2_xattr_value_root *)obj;
>> -		et->et_root_el = &xv->xr_list;
>>  		et->et_ops = &ocfs2_xattr_et_ops;
>>   
> Since there is only one line, the brackets are unnecessary. I don't  
> recall whether checkpatch or "make sparse" will complain this. ;)

	It's checkpatch, but these go away in a later patch.

Joel

-- 

Life's Little Instruction Book #109

	"Know how to drive a stick shift."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
