#
# Location update event. This is event type is required for
# all implementations
#
class LocationUpdateEvent < AssetEvent
      
  # Callbacks
  after_initialize :set_defaults
      
  # Associations
  
  # Each event has a location_id and a location description 
  belongs_to  :parent,  :class_name => 'Asset', :foreign_key => :parent_id
      
  validates   :parent, :presence => true
      
  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------
  # set the default scope
  default_scope { where(:asset_event_type_id => AssetEventType.find_by_class_name(self.name).id).order(:event_date) }
    
  # List of hash parameters allowed by the controller
  FORM_PARAMS = [
    :parent_key
  ]
  
  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------
    
  def self.allowable_params
    FORM_PARAMS
  end
    
  #returns the asset event type for this type of event
  def self.asset_event_type
    AssetEventType.find_by_class_name(self.name)
  end

  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------

  # This must be overriden otherwise a stack error will occur  
  def get_update
    parent.object_key unless parent.nil?
  end

  def parent_key=(object_key)
    self.parent = Asset.find_by_object_key(object_key)
  end
  def parent_key
    parent.object_key
  end

  protected
  
  # Set resonable defaults for a new condition update event
  def set_defaults
    super
    typed_asset = Asset.get_typed_asset(asset)
    self.parent ||= typed_asset.parent
    self.asset_event_type ||= AssetEventType.find_by_class_name(self.name)
  end    
  
end
