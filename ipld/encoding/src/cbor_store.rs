use crate::codec::DAG_CBOR;
use cid::{multihash, Cid};
use fvm_ipld_blockstore::{Block, Blockstore};
use serde::{de, ser};

/// Wrapper for database to handle inserting and retrieving ipld data with Cids
pub trait CborStore: Blockstore + Sized {
    /// Get typed object from block store by Cid.
    fn get_cbor<T>(&self, cid: &Cid) -> anyhow::Result<Option<T>>
    where
        T: de::DeserializeOwned,
    {
        match self.get(cid)? {
            Some(bz) => {
                let res = crate::from_slice(&bz)?;
                Ok(Some(res))
            }
            None => Ok(None),
        }
    }

    /// Put an object in the block store and return the Cid identifier.
    fn put_cbor<S>(&self, obj: &S, code: multihash::Code) -> anyhow::Result<Cid>
    where
        S: ser::Serialize,
    {
        let bytes = crate::to_vec(obj)?;
        self.put(code, &Block { codec: DAG_CBOR, data: &bytes })
    }
}

impl<T: Blockstore> CborStore for T {}
